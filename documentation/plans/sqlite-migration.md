# Plan: SQLite Support for Beatseek

## Context

Beatseek is a local music player (Phoenix/LiveView) currently requiring PostgreSQL. The goal is to add SQLite as an alternative adapter, enabling zero-dependency local operation while preserving a clear path to Postgres for a potential future SaaS/streaming deployment. A data import/export mechanism bridges the two.

## Strategic Recommendation: SQLite-first Locally, Postgres for SaaS

**Lean toward SQLite for local use.** The rationale:
- Personal music collections are bounded datasets — SQLite handles millions of rows trivially
- No separate server process; single file, trivial backup/migration
- macOS ecosystem pattern (Things, Bear, many DAWs use SQLite)
- Ecto's abstraction minimizes per-adapter code — most application code is untouched
- If SaaS materializes, migrating to Postgres is a well-understood path

**Postgres remains first-class.** Nothing is removed; it stays the production/SaaS adapter.

---

## Postgres-specific Features Inventory

| Feature | Location | Issue |
|---|---|---|
| `CREATE EXTENSION citext` | `priv/repo/migrations/20230112070014_create_users_auth_tables.exs:5` | Postgres-only extension |
| `:citext` column type | Same migration, line 8 | Not supported in SQLite |
| Oban job queue | `config/config.exs:32-35`, `priv/repo/migrations/20230120072525_add_oban_jobs_table.exs` | Oban ≥ 2.17 adds `Oban.Engines.Lite` for SQLite; current pin is `~> 2.13` |

**Good news:** `notifications.type` is already `:string` (not a Postgres enum), binary token storage works in SQLite, and all timestamp types (`utc_datetime_usec`, `naive_datetime`) are supported by `ecto_sqlite3`.

---

## Implementation Plan

### Step 1 — Dependencies (`mix.exs`)
- Add `{:ecto_sqlite3, "~> 0.18"}`
- Bump Oban from `~> 2.13` to `~> 2.17` to gain `Oban.Engines.Lite` (SQLite engine)
  - If Oban SQLite engine is unavailable at the current version, fallback: configure Oban with `engine: Oban.Engines.Basic` and skip the Oban jobs migration for SQLite mode (jobs run inline via `Task.Supervisor`)

### Step 2 — Configuration

**`config/config.exs`**
Add adapter-aware Oban config that selects engine based on runtime adapter.

**`config/dev.exs`**
Add a commented SQLite example alongside the existing Postgres config:
```elixir
# SQLite (local, zero-config)
config :beatseek, Beatseek.Repo,
  adapter: Ecto.Adapters.SQLite3,
  database: Path.expand("../data/beatseek_dev.db", __DIR__)

# Postgres (default)
config :beatseek, Beatseek.Repo,
  username: "postgres", password: "postgres",
  hostname: "localhost", database: "beatseek_dev", pool_size: 10
```

**`config/runtime.exs`**
Detect adapter via `DATABASE_ADAPTER` env var (`"sqlite"` | `"postgres"`, default `"postgres"`). When `sqlite`, configure from `DATABASE_PATH` (default `beatseek.db`); when `postgres`, use existing `DATABASE_URL` logic.

### Step 3 — Repo (`lib/beatseek/repo.ex`)
Select adapter and configure migration path at compile/start time. Set `migration_source` to `"priv/repo/migrations_sqlite"` for SQLite or `"priv/repo/migrations"` for Postgres.

### Step 4 — SQLite Migrations (`priv/repo/migrations_sqlite/`)
Create 5 migration files mirroring the Postgres set, with these changes:

| Postgres | SQLite replacement |
|---|---|
| `execute "CREATE EXTENSION IF NOT EXISTS citext", ""` | Remove entirely |
| `add :email, :citext` | `add :email, :string` |
| Oban jobs table (Postgres schema) | Use Oban's SQLite schema, or skip |

Files to create:
- `20230112070014_create_users_auth_tables.exs`
- `20230113070010_create_artists.exs`
- `20230113212925_create_albums.exs`
- `20230117084126_create_notifications.exs`
- `20230120072525_add_oban_jobs_table.exs`

### Step 5 — Email Case Handling (`lib/beatseek/accounts/user.ex`)
Add `String.downcase/1` to the email normalization step in the changeset to remove the dependency on `citext` for case-insensitive uniqueness. This is correct behavior regardless of adapter and a best practice.

### Step 6 — Import/Export Mix Tasks

**Scope:** artists, albums, notifications only. Users and tokens are excluded (security; users re-register).

**Format:** JSON (human-readable, portable, no external tooling required).

Files to create:
- `lib/mix/tasks/beatseek/db/export.ex` — `mix beatseek.db.export [--output path/to/file.json]`
- `lib/mix/tasks/beatseek/db/import.ex` — `mix beatseek.db.import [--input path/to/file.json]`

Export reads from the configured Repo and serializes artists → albums → notifications (order preserves FKs on import). Import uses `Repo.insert_all` with `on_conflict: :replace_all` to be idempotent.

### Step 7 — Alias Updates (`mix.exs`)
```elixir
"ecto.setup.sqlite": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
```
Driven by `DATABASE_ADAPTER=sqlite` env var so existing `mix setup` still works for Postgres.

---

## Files Modified
- `mix.exs` — add `ecto_sqlite3`, bump Oban
- `config/config.exs` — adapter-aware Oban engine
- `config/dev.exs` — SQLite example config
- `config/runtime.exs` — `DATABASE_ADAPTER` detection + SQLite path config
- `lib/beatseek/repo.ex` — migration path selection
- `lib/beatseek/accounts/user.ex` — email lowercase normalization

## Files Created
- `priv/repo/migrations_sqlite/*.exs` (5 files)
- `lib/mix/tasks/beatseek/db/export.ex`
- `lib/mix/tasks/beatseek/db/import.ex`

---

## Verification

1. **SQLite path:** `DATABASE_ADAPTER=sqlite mix ecto.setup` → creates `beatseek_dev.db`, runs all 5 SQLite migrations, app starts successfully
2. **Postgres path:** `mix ecto.setup` (no env var) → existing behavior unchanged
3. **Email case:** Register with `USER@EXAMPLE.COM`, verify login works with `user@example.com`
4. **Export:** `mix beatseek.db.export --output /tmp/data.json` → JSON file with artists/albums/notifications
5. **Import (cross-DB):** Start fresh SQLite DB, `mix beatseek.db.import --input /tmp/data.json` → data appears in SQLite instance
6. **Oban:** Background verification jobs run in both modes (or inline in SQLite mode if engine unsupported)

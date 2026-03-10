---
name: create-migrations
description: Safe Ecto migration patterns — when to add vs. modify migrations, naming, reversibility, and SQLite compatibility.
---

# Migrations in Ecto

Keep schema changes safe, testable, and reversible.

## Commands

```bash
# Generate a new migration
mix ecto.gen.migration create_albums

# Run all pending migrations
mix ecto.migrate

# Roll back the most recent migration
mix ecto.rollback

# Roll back N steps
mix ecto.rollback --step 2

# Reset (drop, recreate, migrate, seed)
mix ecto.reset
```

For the SQLite migration path, migrations live in `priv/repo/migrations_sqlite/` and are selected via `DATABASE_ADAPTER=sqlite`. See `documentation/plans/sqlite-migration.md`.

---

## Rules

- Migrations **must** be reversible — always implement `down/0`
- You may edit migrations freely on **feature branches**; never edit them after merging to `main` (use a new migration instead)
- Migrations **must** be idempotent where practical — use `create_if_not_exists`, check before dropping
- Do **not** bundle application code that references new columns in the same commit; deploy the migration first, then the code

---

## Migration Structure

```elixir
defmodule Beatseek.Repo.Migrations.AddSpotifyIdToArtists do
  use Ecto.Migration

  def up do
    alter table(:artists) do
      # spotify_id nullable initially — populated by verification step
      add :spotify_id, :string
    end

    # Index for the verification lookup: Artists.get_by_spotify_id/1
    create unique_index(:artists, [:spotify_id])
  end

  def down do
    drop_if_exists unique_index(:artists, [:spotify_id])

    alter table(:artists) do
      remove :spotify_id
    end
  end
end
```

---

## Naming Conventions

File names are timestamp-prefixed by `mix ecto.gen.migration`:

| Action | Example |
|---|---|
| Create table | `create_artists` |
| Add column | `add_spotify_id_to_artists` |
| Remove column | `remove_deprecated_source_from_albums` |
| Add index | `add_index_to_albums_artist_id` |
| Rename column | `rename_url_to_image_url_on_artists` |

---

## Reversibility Patterns

```elixir
# Adding a column — easy to reverse
def up, do: alter(table(:albums), do: add(:year, :string))
def down, do: alter(table(:albums), do: remove(:year))

# Adding a table — reverse drops it
def up, do: create(table(:notifications), do: ...)
def down, do: drop(table(:notifications))

# Adding an index — always drop the index in down/0
def up, do: create(unique_index(:albums, [:artist_id, :name]))
def down, do: drop_if_exists(unique_index(:albums, [:artist_id, :name]))
```

---

## SQLite / Postgres Compatibility

Beatseek is migrating toward supporting SQLite alongside Postgres. When writing migrations:

| Postgres feature | SQLite-safe alternative |
|---|---|
| `execute "CREATE EXTENSION citext"` | Remove entirely; use `String.downcase/1` in changeset |
| `add :email, :citext` | `add :email, :string` |
| Oban jobs table (Postgres schema) | Use SQLite migration variant in `priv/repo/migrations_sqlite/` |
| `:utc_datetime_usec` | Supported in both |
| `:string`, `:integer`, `:boolean` | Supported in both |

If a migration uses Postgres-only features, create a parallel version in `priv/repo/migrations_sqlite/` with the SQLite-safe equivalent.

---

## Backward Compatibility — Additive First

For changes to tables that have running application code:

1. **Add column as nullable** first (no application code change needed)
2. **Deploy application code** that writes to the new column
3. **Add NOT NULL constraint** in a follow-up migration after data is populated

```elixir
# Step 1 — deploy this migration before the code change
def up do
  alter table(:artists) do
    add :verified_at, :utc_datetime_usec  # nullable initially
  end
end

# Step 3 — later, after all rows are populated
def up do
  alter table(:artists) do
    modify :verified_at, :utc_datetime_usec, null: false
  end
end
```

---

## Testing Migrations

- Tests use `Ecto.Adapters.SQL.Sandbox` — migrations are automatically run before the test suite
- Use fixtures in `test/support/fixtures/` rather than manual `Repo.insert!` calls in tests
- To verify a migration's `down/0`: `mix ecto.rollback --step 1` and confirm the app still starts

## Related Skills

- `wrap-in-transactions` — Writing atomic multi-step operations using the migrated schema
- `data-steward` agent — Reviewing migration safety in PRs

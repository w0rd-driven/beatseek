---
name: write-plan
description: Write a step-by-step Elixir/Phoenix implementation plan with TDD entry points, migrations, contexts, workers, and verification checkpoints.
---

# Writing Plans for Beatseek

Turn a confirmed design into a sequence of small, testable steps. Plans live in `documentation/plans/`.

## Structure

1. **Context** — 1–2 sentences on the problem being solved and why
2. **Data Model** — Ecto migrations and schema changes (one commit per migration)
3. **Context & Logic** — New or modified context functions, transformers, workers
4. **Web Layer** — LiveView modules, components, or controller changes (if applicable)
5. **Tests (TDD)** — ExUnit tests at each step; write failing tests first, then implement
6. **Quality Gates** — `mix check` clean before marking complete
7. **Rollout / Observability** — Migration safety, env var changes, Fly.io deploy notes

## Task Format

Each step should be independently committable:

```
- [ ] Create migration: add :spotify_id to :artists
- [ ] Write failing test: Artists.get_by_spotify_id/1 returns nil when not found
- [ ] Implement Artists.get_by_spotify_id/1
- [ ] Write failing test: Verification.Spotify.verify/1 updates artist spotify_id
- [ ] Implement verification update in Beatseek.Verification.Spotify
- [ ] Run mix check; confirm clean
- [ ] Update CLAUDE.md if architectural pattern changes
```

## Step Types

| Step Type | Commit Scope |
|---|---|
| Migration | One migration file only; no application code referencing new columns |
| Context function | Module + test file |
| Oban worker | Worker module + test using `Oban.Testing` |
| LiveView | LiveView module + LiveViewTest |
| Transformer | Transformer module + unit test |
| Quality gate | Run `mix check`; fix any issues before next step |

## Example Plan: Add Spotify ID to Artists

```markdown
## Context
Artists discovered via ID3 scanning don't have a Spotify ID.
Storing it avoids repeated search queries on re-verification.

## Steps

### 1. Data Model
- [ ] `mix ecto.gen.migration add_spotify_id_to_artists`
- [ ] Add nullable `:spotify_id :string` column + unique index
- [ ] Add `down/0` rollback
- [ ] Commit: `feat(migrations): add spotify_id to artists`

### 2. Context
- [ ] Write failing test: `Artists.get_by_spotify_id/1`
- [ ] Implement `Artists.get_by_spotify_id/1`
- [ ] Write failing test: `Artists.update_artist/2` with `:spotify_id`
- [ ] Confirm existing upsert changeset casts `:spotify_id`
- [ ] Commit: `feat(artists): add get_by_spotify_id and spotify_id upsert`

### 3. Verification
- [ ] Write failing test: `Verification.Spotify.get_artist/1` stores `spotify_id`
- [ ] Update `SpotifyArtistTransformer` to include `:spotify_id`
- [ ] Update `Verification.Spotify.update_artist_image/2` to also set `:spotify_id`
- [ ] Commit: `feat(verification): persist spotify_id on artist verification`

### 4. Quality Gates
- [ ] `mix check` — all green
- [ ] `mix dialyzer` — no new warnings
```

## After Writing the Plan

- Save to `documentation/plans/<descriptive-name>.md`
- Use `execute-plan` to work through the steps in batches

## Related Skills

- `execute-plan` — Execute a plan in batches with checkpoints
- `create-migrations` — Migration safety and patterns
- `verify-before-completion` — Evidence before claiming a step is done

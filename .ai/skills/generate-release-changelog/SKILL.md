---
name: generate-release-changelog
description: Generate release notes by comparing branches, grouping commits by conventional type, and enriching with GitHub issue context.
---

# Change Log Generation

## Dependencies

- Git
- GitHub CLI (`gh`)
- `jq`

If any are missing, run `install-tooling`.

## Procedure

1. **Identify the comparison range**

   For a release from `main` since the last tag:

   ```bash
   git log $(git describe --tags --abbrev=0)..HEAD --oneline
   # or, if no tags exist yet:
   git log --oneline
   ```

   For the diff stat:

   ```bash
   git diff $(git describe --tags --abbrev=0)...HEAD --stat
   ```

2. **Extract issue references**

   Scan commit messages for `#NNN` references and fetch issue titles:

   ```bash
   gh issue view <NNN> --json title,labels -q '"\(.title) [\(.labels | map(.name) | join(", "))]"'
   ```

3. **Categorise changes**

   Group commits by conventional commit type (from the prefix or from context):

   - **Features** (`feat`) — New functionality
   - **Bug Fixes** (`fix`) — Issues resolved
   - **Performance** (`perf`) — Speed or resource improvements
   - **Refactors** (`refactor`) — Internal restructuring, no behaviour change
   - **Chores** (`chore`, `ci`, `docs`, `test`) — Maintenance, dependency updates, CI changes
   - **Database Changes** — Any PR with the `migrations` label or migration files in diff

4. **Format the change log**

   ```markdown
   ## Change Log — v<VERSION>

   ### Features
   - **#62** feat(sqlite): add SQLite as an optional database adapter
   - **#65** feat(scanner): parse disc number from ID3 tags

   ### Bug Fixes
   - **#57** fix(scanner): prevent scan upsert from overwriting verified album data

   ### Chores
   - **#66** chore: bump oban from ~> 2.13 to ~> 2.17

   ### Database Changes
   - `add_spotify_id_to_artists` — nullable `:spotify_id` column, unique index
   - SQLite migration set in `priv/repo/migrations_sqlite/`

   ---
   *Generated from $(git describe --tags --abbrev=0)..HEAD*
   ```

5. **Offer to update the release PR**

   Ask whether to append the change log to the release PR body:

   ```bash
   CURRENT=$(gh pr view <PR-NUMBER> --json body -q '.body')
   gh pr edit <PR-NUMBER> --body "$CURRENT

   ---

   $CHANGELOG"
   ```

## Related Skills

- `create-release` — Creates the release tag and PR that this changelog enriches
- `use-github-cli` — `gh` command reference

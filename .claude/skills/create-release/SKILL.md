---
name: create-release
description: Cut a Beatseek release — tag main, create a backup branch, open a GitHub release draft, and confirm Fly.io deployment.
---

# Release Creation Workflow

## Dependencies

- Git
- GitHub CLI (`gh`)
- `jq`

If any are missing, run `install-tooling`.

## Scripts

This skill uses three shell scripts in the same directory as this file (`.claude/skills/create-release/`):

- `prepare-release.sh` — Saves git state, stashes changes, generates the version number
- `create-release-tag.sh` — Creates the backup branch and the annotated release tag on `main`
- `restore-git-state.sh` — Restores the original branch and un-stashes changes

## Version Format

`YYYY.MM.DD.N` — `N` is a 1-based ordinal for multiple releases on the same date.
Example: `2026.03.10.1`, `2026.03.10.2`

The `prepare-release.sh` script derives `N` automatically from existing git tags for today.

---

## Workflow Steps

### 1. Prepare Release

Run from the repo root:

```bash
bash .claude/skills/create-release/prepare-release.sh
```

Parse and store the key=value output:

- `ORIGINAL_BRANCH` — branch to restore at the end
- `STASH_CREATED` — whether changes were stashed (`true`/`false`)
- `STASH_MSG` — stash identifier for restoration
- `VERSION` — computed release version (e.g., `2026.03.10.1`)

### 2. Verify Before Tagging

Run the full test suite against `main` before creating any tags — see `verify-before-completion`:

```bash
git checkout main && git pull origin main
mix test
```

If tests fail, run `restore-git-state.sh` immediately and report the failure. Do not proceed.

### 3. Create Release Tag

```bash
bash .claude/skills/create-release/create-release-tag.sh "$VERSION"
```

Parse and store:

- `MAIN_SHA` — commit hash of `main` before the release
- `BACKUP_BRANCH` — e.g., `v2026.03.10.1-backup` (disaster recovery)
- `TAG_NAME` — e.g., `v2026.03.10.1`

### 4. Generate Change Log

Run `generate-release-changelog` to produce release notes, then create the GitHub release:

```bash
gh release create "$TAG_NAME" \
  --title "$TAG_NAME" \
  --target main \
  --draft \
  --notes "$(cat release-notes.md)"
```

Add the `migrations` label if `priv/repo/migrations/` has new files since the previous tag.

### 5. Restore Original Git State

```bash
bash .claude/skills/create-release/restore-git-state.sh "$ORIGINAL_BRANCH" "$STASH_CREATED" "$STASH_MSG"
```

### 6. Confirm Fly.io Deployment

The `fly.yml` GitHub Actions workflow deploys automatically on push to `main`. The tag push does not trigger it — it is triggered by the commit on `main` that was already there. Verify the latest run:

```bash
gh run list --workflow fly.yml --limit 3
gh run view <run-id> --log
```

For a manual redeploy if needed:

```bash
fly deploy --app beatseek
```

### 7. Report Results

Provide a summary:

- Release tag and GitHub release URL
- Backup branch name and `MAIN_SHA`
- Whether migrations are included (and any manual steps)
- Fly.io deployment status

---

## Error Handling

- If `mix test` fails before tagging: run `restore-git-state.sh` and stop — do not tag a broken release
- If `create-release-tag.sh` fails: run `restore-git-state.sh`; delete the local tag if partially created (`git tag -d v$VERSION`)
- If the Fly.io deploy fails: check `fly logs --app beatseek` — the backup branch allows a fast rollback via `fly deploy` from the backup SHA

## Related Skills

- `generate-release-changelog` — Generate release notes before step 4
- `verify-before-completion` — Evidence-based verification before tagging
- `use-github-cli` — `gh release` and `gh run` command reference

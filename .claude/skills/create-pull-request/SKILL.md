---
name: create-pull-request
description: Create a GitHub pull request with structured description, labels, and risk analysis
---

# Pull Request

## Dependencies

- GitHub CLI (`gh`) — see `use-github-cli`

If not installed, run `install-tooling`.

## Procedure

Use `gh pr create` to open the PR. Every PR should:

- Target `main` unless directly instructed otherwise
- Have a title following conventional commit format: `type(scope): short description`
  - Example: `feat(sqlite): add ecto_sqlite3 adapter support`
- Include a structured description (see template below)
- Have a mandatory **Risk Analysis** section
- Use appropriate labels

## Labels

Create labels if they don't exist:

- `feat`, `fix`, `chore`, `refactor`, `docs`, `test`, `perf`, `security`
- `migrations` — includes Ecto migration files
- `breaking-change` — changes context API signatures or schema in a backward-incompatible way
- `wip`, `needs-review`, `ready-for-merge`

## Steps

1. **Gather context**

   ```bash
   git log main..HEAD --oneline       # commits in this branch
   gh issue list --state open          # find the linked issue if applicable
   ```

2. **Generate the PR title**

   Follow the conventional commit format (same as `create-conventional-commit`):
   `type(scope): short description`

3. **Write the PR description** using this template:

   ```markdown
   ## Summary

   - [bullet: what changed]
   - [bullet: why it changed]

   Closes #<issue-number>  (if applicable)

   ## Test Plan

   - [ ] `mix test` passes
   - [ ] [manual steps or scenario to verify]

   ## Risk Analysis

   | Metric | Level | Notes |
   |--------|-------|-------|
   | **Schema changes** | Yes/No | [migration details or "None"] |
   | **Breaking changes** | Yes/No | [what breaks or "None"] |
   | **Deployment steps** | Yes/No | [manual steps or "Standard deploy"] |
   | **Rollback plan** | | [how to revert] |
   ```

4. **Create the PR**

   ```bash
   gh pr create \
     --base main \
     --title "feat(sqlite): add ecto_sqlite3 adapter support" \
     --label "feat,migrations" \
     --body "$(cat pr-body.md)"
   ```

5. **Verify CI status**

   After creation, watch for the four required checks to pass:
   - Build and Test
   - Elixir Quality Checks (format, credo, xref, sobelow)
   - Dialyzer
   - (Nightly integration test runs on schedule)

   ```bash
   gh pr checks <PR-number> --watch
   ```

## Related Skills

- `use-github-cli` — `gh` command reference
- `create-conventional-commit` — commit message format (also used for PR titles)
- `generate-release-changelog` — generate release notes from merged PRs

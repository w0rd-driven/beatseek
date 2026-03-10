---
name: create-feature-branch
description: Create a git feature branch from main with GitHub-issue-convention naming (feat/, fix/, hotfix/, etc.)
---

# Create a Feature Branch

## Requirements

Start from a **clean working directory** on the **latest `main` branch**. If the directory isn't clean, offer to stash changes with a descriptive name using `stash-and-switch-branch`.

A GitHub issue number is strongly preferred for traceability. If the work relates to an open issue, use its number. If not, it's acceptable to proceed without one for exploratory or chore work.

## Steps

1. **Ensure a clean, up-to-date starting point**

   ```bash
   git checkout main
   git pull origin main
   git status  # must be clean before branching
   ```

2. **Determine the branch type**

   | Type | Use for |
   |---|---|
   | `feat` | New features or functionality |
   | `fix` | Bug fixes |
   | `hotfix` | Urgent fixes for production issues |
   | `chore` | Maintenance, dependency updates, non-functional changes |
   | `refactor` | Code restructuring without behaviour change |
   | `docs` | Documentation-only changes |

3. **Generate the branch name**

   Format: `<type>/<issue-number>-<short-description>`

   - Use hyphens to separate words in the description
   - Keep the description concise (3–5 words)
   - Lowercase only

   Examples:
   - `feat/62-add-sqlite-support`
   - `fix/57-scan-upsert-overwrites-verified-data`
   - `chore/update-oban-to-2-17`
   - `docs/add-sqlite-migration-plan`

4. **Create and switch to the branch**

   ```bash
   git checkout -b feat/62-add-sqlite-support
   ```

5. **Confirm**

   ```bash
   git branch --show-current
   ```

   Report the new branch name to the user.

## Notes

- If the working directory has unstaged changes, run `stash-and-switch-branch` before branching
- If there is no related issue and one seems warranted, offer to create one with `gh issue create`

## Related Skills

- `stash-and-switch-branch` — Save in-progress work before branching
- `use-github-cli` — Create issues and PRs
- `create-pull-request` — Open a PR from this branch when the work is done

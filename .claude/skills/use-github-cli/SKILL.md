---
name: use-github-cli
description: Interact with GitHub using the gh CLI — pull requests, issues, releases, and workflow runs.
---

# GitHub CLI (`gh`) Usage

Reference for common `gh` operations used across Beatseek workflows.

## Prerequisites

Ensure `gh` is installed and authenticated:

```bash
gh --version
gh auth status
```

If not installed, run `install-tooling`.

---

## Pull Request Workflows

### Create a PR

```bash
gh pr create \
  --base main \
  --head feat/my-feature \
  --title "feat(scanner): add disc number parsing" \
  --body "$(cat <<'EOF'
## Summary
- Parses disc number from ID3 tag
- Stores as nullable integer on albums table

## Test plan
- [ ] Run scanner against multi-disc album
- [ ] Verify disc_number populated in DB
EOF
)"
```

### View, List, and Diff PRs

```bash
gh pr list
gh pr view 42
gh pr view 42 --web        # open in browser
gh pr diff 42
gh pr diff 42 --name-only  # changed files only
```

### Checkout a PR Branch

```bash
gh pr checkout 42
```

### Update PR Body

```bash
CURRENT=$(gh pr view 42 --json body -q '.body')
gh pr edit 42 --body "$(cat <<'EOF'
## Risk Analysis
...

---

$CURRENT
EOF
)"
```

### Read and Post PR Comments

```bash
gh pr view 42 --comments
gh pr comment 42 --body "LGTM — verified locally with test collection"
```

---

## Managing PR Metadata

### Labels

```bash
gh pr edit 42 --add-label "feat,needs-review"
gh pr edit 42 --remove-label "wip"
```

Available labels for Beatseek PRs: `feat`, `fix`, `chore`, `refactor`, `docs`, `test`, `perf`, `security`, `migrations`, `breaking-change`, `wip`, `needs-review`, `ready-for-merge`

### Reviewers and Assignees

```bash
gh pr edit 42 --add-reviewer username
gh pr edit 42 --assignee "@me"
```

---

## Issue Workflows

```bash
gh issue list
gh issue view 57
gh issue create --title "Fix scan upsert overwriting verified data" --body "..."
gh issue close 57 --comment "Fixed in #58"
```

---

## GitHub Actions

### View Workflow Runs

```bash
gh run list
gh run view 456 --log
gh run watch 456   # stream live output
```

### Trigger a Workflow

```bash
gh workflow list
gh workflow run "Deploy to Fly.io" --ref main
```

---

## Releases

```bash
# Create a release from a tag
gh release create v2026.03.10.1 \
  --title "v2026.03.10.1" \
  --notes "$(cat CHANGELOG.md)" \
  --target main

gh release list
gh release view v2026.03.10.1
```

---

## Fetching PR JSON

```bash
# Get PR metadata as JSON for scripting
gh pr view 42 --json number,title,author,baseRefName,headRefName,body,state

# Get just the head branch name
gh pr view 42 --json headRefName -q '.headRefName'
```

## Related Skills

- `create-pull-request` — Full PR creation workflow with labels and risk analysis
- `review-pull-request` — Orchestrated multi-perspective PR review
- `create-release` — Release tagging and deployment workflow

---
name: review-pull-request
description: Orchestrate a comprehensive multi-perspective PR review using the bootstrap script and all reviewer agents.
---

# Multi-Perspective PR Review

Execute a comprehensive code review by running the bootstrap script to handle all mechanical setup, then launching reviewer agents against the generated artifacts.

## Input Validation

If `$ARGUMENTS` does not contain a valid GitHub PR URL or bare PR number, explain the issue and ask for one. Accepted formats:
- `https://github.com/w0rd-driven/beatseek/pull/###`
- A bare PR number (e.g., `42`)

## Prerequisites

- GitHub CLI (`gh`) authenticated
- `jq`

If missing, run `install-tooling`.

## Scripts

This skill uses two shell scripts in `.claude/skills/review-pull-request/scripts/`:

- `pr-review-bootstrap.sh` — Stashes work, checks out the PR branch, generates the diff and file list, detects change categories, writes a context summary, and emits a structured key=value block
- `pr-review-cleanup.sh` — Removes all generated artifacts after the review is complete

---

## Workflow

### 1. Bootstrap

Run from the repo root:

```bash
bash .claude/skills/review-pull-request/scripts/pr-review-bootstrap.sh "$ARGUMENTS"
```

The script outputs a block delimited by `===PR_REVIEW_BOOTSTRAP_START===` / `===PR_REVIEW_BOOTSTRAP_END===`. Parse this block to extract all key=value pairs. Key fields:

| Variable | Description |
|---|---|
| `PR_NUMBER` | Numeric PR ID |
| `DIFF_FILE` | Path to `documentation/pr-files/pr-N-full.diff` |
| `CONTEXT_FILE` | Path to `documentation/pr-files/pr-N-context.md` |
| `FILES_DIR` | Path to `documentation/pr-files/pr-N-files/` |
| `ISSUES_FILE` | Path to `documentation/pr-files/pr-N-issues.txt` (if issue linked) |
| `HAS_FRONTEND` | `yes`/`no` — LiveView, HEEx, assets changed |
| `HAS_MIGRATIONS` | `yes`/`no` — Ecto migrations changed |
| `HAS_INFRA` | `yes`/`no` — fly.toml, Dockerfile, CI changed |
| `HAS_CONFIG` | `yes`/`no` — config/, .env.example changed |
| `HAS_WORKERS` | `yes`/`no` — Oban worker files changed |
| `HAS_AUTH` | `yes`/`no` — auth/accounts/session files changed |
| `ISSUE_NUMBER` | Linked GitHub issue number, or `none` |

**If the script fails**, it automatically rolls back (restores original branch, pops stash, moves untracked files back). Do NOT attempt manual recovery.

---

### 2. Agent Selection

**Always run:**
- `developer-reviewer`
- `security-reviewer`
- `qa-reviewer`

**Run conditionally:**

| Condition | Add agent |
|---|---|
| `HAS_MIGRATIONS=yes` OR `HAS_INFRA=yes` OR `HAS_CONFIG=yes` | `devops-reviewer` |
| `HAS_MIGRATIONS=yes` | `data-steward` |
| `HAS_FRONTEND=yes` | `ui-ux-reviewer` |
| `HAS_WORKERS=yes` OR large context/query changes | `performance-analyst` |
| Feature work (not chore/refactor) | `product-reviewer` |

---

### 3. Launch Agents

**CRITICAL**: Launch all applicable agents in a **single message** using multiple Task tool calls for true parallel execution.

Each agent receives the path to `DIFF_FILE`. Agents that need additional context (data-steward, quality-engineer) can also read `CONTEXT_FILE` and `FILES_DIR`.

---

### 4. Compile the Report

Once all agents complete, compile their outputs:

```markdown
## PR Review: #<NUMBER> — <title>

### Executive Summary

**Overall Risk**: [Low/Medium/High/Critical]
**Agents Run**: [list with trigger reason]
**Key Actions Before Merge**: [bulleted blockers]

### Linked Issue
[Issue title and summary, or "No linked issue"]

### Reviews by Dimension

[Each agent's full output]

### Aggregate Metrics

| Dimension | Rating | Risk |
|---|---|---|
| Developer | X.X/5.0 | |
| Security | X.X/5.0 | |
| QA | X.X/5.0 | |
| ... | | |
**Average**: X.X/5.0

### Prioritised Actions

**Blockers (must fix before merge):**

**Recommended:**

**Nice to Have:**
```

---

### 5. Cleanup

```bash
bash .claude/skills/review-pull-request/scripts/pr-review-cleanup.sh $PR_NUMBER
```

The cleanup script will refuse to delete artifacts if a stash is still pending. Run `restore-stashed-changes` first, then re-run cleanup. Or pass `--force` to skip the guard.

**Note**: Do NOT run `restore-stashed-changes` automatically — let the user decide when to restore their previous work.

## Related Skills

- `restore-stashed-changes` — Restore your work after the review is complete
- `use-github-cli` — `gh pr diff` and `gh pr view` reference
- `install-tooling` — Install missing prerequisites

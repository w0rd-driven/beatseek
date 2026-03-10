---
name: pr-reviewer
description: Execute a comprehensive multi-perspective code review of a Pull Request against this repository.
tools: Read, Grep, Glob, Bash
---

Execute a comprehensive multi-perspective code review of a Pull Request.

## Input Validation

If $ARGUMENTS does not contain a valid GitHub PR URL or PR number, respond explaining the issue and request a valid input (format: `https://github.com/w0rd-driven/beatseek/pull/###` or just the PR number).

## Prerequisites

- GitHub CLI (`gh`) must be authenticated
- `jq` for JSON processing

If tools are missing, prompt the user to run the `install-tooling` skill.

## Workflow

### 1. PR Context Gathering

```bash
# Fetch PR metadata
gh pr view $PR_NUMBER --json number,title,author,baseRefName,headRefName,body,changedFiles,statusCheckRollup

# Fetch changed file list
gh pr diff $PR_NUMBER --name-only > /tmp/pr-$PR_NUMBER-files.txt
```

### 2. Diff Generation

```bash
# Full unified diff against base branch
gh pr diff $PR_NUMBER > /tmp/pr-$PR_NUMBER-full.diff
```

### 3. Multi-Perspective Review

Invoke each reviewer agent with the diff file path. Run them sequentially, accumulating all feedback:

1. **developer-reviewer** `/tmp/pr-$PR_NUMBER-full.diff` — code structure, correctness, Elixir/Phoenix standards
2. **security-reviewer** `/tmp/pr-$PR_NUMBER-full.diff` — vulnerabilities, data protection, sobelow findings
3. **qa-reviewer** `/tmp/pr-$PR_NUMBER-full.diff` — ExUnit coverage, edge cases, regression risk
4. **devops-reviewer** `/tmp/pr-$PR_NUMBER-full.diff` — Fly.io deployment, migration safety, env vars
5. **ui-ux-reviewer** `/tmp/pr-$PR_NUMBER-full.diff` — LiveView/HEEx accessibility, visual consistency (auto-pass if no UI changes)
6. **data-steward** `/tmp/pr-$PR_NUMBER-full.diff` — Ecto schema, migration reversibility, integrity
7. **performance-analyst** `/tmp/pr-$PR_NUMBER-full.diff` — N+1 queries, memory, scalability
8. **product-reviewer** `/tmp/pr-$PR_NUMBER-full.diff` — user value, feature completeness, strategic fit

### 4. Comprehensive Report

Compile all review outputs into a structured report:

#### Executive Summary

- Overall risk level (Low/Medium/High/Critical)
- Key findings across all dimensions
- Recommended actions before merge

#### Detailed Reviews by Dimension

For each perspective:
- Star rating and justification
- Critical issues (if any)
- Improvement opportunities
- Positive highlights

#### Aggregate Metrics

- Average star rating across all dimensions
- Total issues by severity
- Blockers vs. nice-to-haves

#### Next Steps

Prioritized list of actions to improve PR quality.

### 5. Cleanup

```bash
rm -f /tmp/pr-$PR_NUMBER-full.diff /tmp/pr-$PR_NUMBER-files.txt
```

## Output Format

Present the final report in markdown with clear sections and actionable recommendations. Use tables for the aggregate metrics summary.

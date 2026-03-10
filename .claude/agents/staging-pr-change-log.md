---
name: staging-pr-change-log
description: Update a staging/release PR with a compiled change log from all linked PRs.
tools: Read, Grep, Glob, Bash
model: opus
---

Given the following PR URL or number: $ARGUMENTS, perform these steps:

1. **Fetch the staging PR body** using `gh pr view $PR_NUMBER --json body,title,number`

2. **Identify linked PRs** in the body — look for references like `#1234`, `Merges #1234`, or full GitHub PR URLs

3. **For each linked PR**, fetch:
   - PR title and description: `gh pr view $LINKED_PR --json title,body,mergedAt,author`
   - Linked GitHub issues (referenced via `Closes #`, `Fixes #`, or `Resolves #` in the PR body)
   - Issue details: `gh issue view $ISSUE_NUMBER --json title,body,labels`

4. **Compile a change log** that includes for each linked PR:
   - PR number and title
   - Author
   - Linked issue number and summary (if any)
   - A one-sentence description of what changed (derived from the PR description)
   - Type of change: `feat`, `fix`, `chore`, `refactor`, etc. (inferred from PR content or conventional commit prefix)

5. **Format the change log** in markdown:

```markdown
## Change Log

### Features
- **#123** — [Title] ([author]) — closes #456
  [One-sentence description]

### Bug Fixes
- **#124** — [Title] ([author]) — closes #457
  [One-sentence description]

### Chores / Refactors
- **#125** — [Title] ([author])
  [One-sentence description]

---
*Generated [date]*
```

6. **Update the staging PR body** by appending or replacing the `## Change Log` section:

```bash
gh pr edit $PR_NUMBER --body "$(new body with change log appended)"
```

Preserve any existing content in the PR body above the change log section. If a `## Change Log` section already exists, replace it with the updated version.

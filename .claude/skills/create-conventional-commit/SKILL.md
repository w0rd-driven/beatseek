---
name: create-conventional-commit
description: Create git commits with conventional format (feat:, fix:, refactor:, chore:) and structured messages
---

# Create One or More Relevant Commits

Given the current work being completed and the state of files in Git, create one or more
commits which accurately and clearly describe the changes made and which adhere to the
following guidelines.

## Commit Message Structure

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Required Elements

### Type (Required)

- **feat** — New features or functionality
- **fix** — Bug fixes
- **docs** — Documentation updates only
- **style** — Code formatting, whitespace (no logic changes)
- **refactor** — Code restructuring without changing external behavior
- **test** — Adding, updating, or fixing tests
- **chore** — Maintenance tasks, dependency updates, build process
- **ci** — CI/CD configuration and script changes
- **perf** — Performance improvements
- **revert** — Reverting previous commits

### Description (Required)

- Brief summary of the change
- Use imperative mood ("add" not "added" or "adds")
- Start with lowercase letter
- No period at the end
- Keep under 50 characters when possible

## Optional Elements

### Scope

Indicates which part of the codebase is affected. Common scopes for Beatseek:

- `scanner` — `Beatseek.Scanner` and related transformers
- `verification` — `Beatseek.Verification.Spotify` and `VerificationWorker`
- `artists` / `albums` / `notifications` — individual contexts
- `accounts` — user auth
- `live` — Phoenix LiveView modules
- `migrations` — Ecto migrations
- `config` — application configuration
- `ci` — GitHub Actions workflows

Examples:
```
feat(scanner): parse disc number from ID3 tags
fix(verification): handle Spotify rate limit response
refactor(albums): extract upsert logic into context
```

### Body

- Explain the "what" and "why", not the "how"
- Wrap lines at 72 characters
- Separate from description with a blank line

### Footer

- Breaking changes: `BREAKING CHANGE: description`
- Issue references: `Closes #123`, `Fixes #456`

## Breaking Changes

Append `!` after type/scope:

```
feat!: remove deprecated scan API
fix(accounts)!: change token storage format
```

## Commit Frequency

- Make small, focused commits
- One logical change per commit
- Avoid mixing context changes (e.g., don't mix a migration with a LiveView change)

## Common Mistakes to Avoid

- Using past tense ("added" instead of "add")
- Mixing multiple unrelated changes in one commit
- Vague messages like "fix stuff" or "updates"
- Forgetting to reference the issue number in the footer when applicable

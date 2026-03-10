---
name: verify-before-completion
description: Run tests, quality checks, and verification commands to confirm work is actually done before committing or claiming success.
---

# Verification Before Completion

## Overview

Claiming work is complete without verification is dishonesty, not efficiency.

**Core principle:** Evidence before claims, always.

**Violating the letter of this rule is violating the spirit of this rule.**

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

## The Gate Function

```
BEFORE claiming any status or expressing satisfaction:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. ONLY THEN: Make the claim

Skip any step = asserting without knowing
```

## Beatseek Verification Commands

| Claim | Command | What to look for |
|---|---|---|
| Tests pass | `mix test` | `X tests, 0 failures` |
| Single test passes | `mix test test/path/file_test.exs:42` | `1 test, 0 failures` |
| Formatting clean | `mix format --check-formatted` | exit 0, no output |
| Credo clean | `mix credo suggest --min-priority=normal` | no issues listed |
| Dialyzer clean | `mix dialyzer` | `done (passed successfully)` |
| Security clean | `mix sobelow` | no vulnerabilities listed |
| Full quality gate | `mix check` | all steps exit 0 |
| Compile clean | `mix compile --warnings-as-errors` | exit 0 |
| Migration works | `mix ecto.migrate && mix ecto.rollback --step 1 && mix ecto.migrate` | no errors |

## Common Failures

| Claim | Requires | Not Sufficient |
|---|---|---|
| Tests pass | `mix test` output: 0 failures | Previous run, "should pass" |
| Credo clean | Credo output: no issues | Partial check, skipped modules |
| Build succeeds | `mix compile` exit 0 | Formatter passing |
| Bug fixed | Test reproducing the bug: passes | Code changed, assumed fixed |
| Regression test works | Red–green cycle verified | Test passes once |
| Worker completes | Oban job state confirmed | Logs look clean |
| Requirements met | Line-by-line checklist | Tests passing |

## Red Flags — STOP

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Done!", "All good!", "Perfect!")
- About to commit without running `mix test`
- Trusting that a file change "obviously works"
- Relying on partial verification ("I checked the main case")
- **Any wording implying success without having run the command**

## Rationalization Prevention

| Excuse | Reality |
|---|---|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence ≠ evidence |
| "Credo passed" | Credo ≠ compiler ≠ tests |
| "Just this once" | No exceptions |
| "Dialyzer is slow" | Run it; it catches real bugs |
| "Partial check is enough" | Partial proves nothing |

## TDD Red-Green Verification

```
✅ Write test → Run (MUST FAIL first) → Implement → Run (must pass)
❌ Write test → Implement → Run (once, passes)
```

A test that was never red may not be testing what you think.

## Key Patterns

**Tests:**

```
✅ [mix test] → [X tests, 0 failures] → "All tests pass"
❌ "Should pass now"
```

**Quality gate:**

```
✅ [mix check] → [all steps exit 0] → "Quality gate clean"
❌ "Linter passed" (linter ≠ full check)
```

**Requirements:**

```
✅ Re-read plan → Create checklist → Verify each item → Report gaps or completion
❌ "Tests pass, step complete"
```

## The Bottom Line

Run the command. Read the output. THEN make the claim.

No shortcuts.

## Related Skills

- `execute-plan` — Uses verification at each batch checkpoint
- `write-plan` — Plans include explicit quality gate steps

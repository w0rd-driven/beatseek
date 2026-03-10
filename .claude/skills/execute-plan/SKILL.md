---
name: execute-plan
description: Execute a multi-step implementation plan with review checkpoints between phases
---

# Executing Plans

## Overview

Load plan, review critically, execute tasks in batches, report for review between batches.

**Core principle:** Batch execution with checkpoints for review.

**Announce at start:** "I'm using the execute-plan skill to implement this plan."

## The Process

### Step 1: Load and Review Plan

1. Read plan file (located in `documentation/plans/` or provided path)
2. Review critically — identify any questions or concerns
3. If concerns: raise them before starting
4. If no concerns: create a TodoWrite task list and proceed

### Step 2: Execute Batch

**Default: First 3 tasks**

For each task:

1. Write failing test (ExUnit unit or integration test)
2. Minimal implementation to make it pass; commit
3. Run quality checks in parallel:
   - `mix test` — tests pass
   - `mix format --check-formatted` — formatting clean
   - `mix credo suggest --min-priority=normal` — no new Credo violations
4. If applicable, verify Oban jobs enqueue/process or PubSub events broadcast correctly
5. Update any relevant docs; mark task complete

### Step 3: Report

When batch is complete:

- Show what was implemented
- Show verification output (test results, credo output)
- Say: "Ready for feedback."

### Step 4: Continue

Based on feedback:

- Apply changes if needed
- Execute next batch
- Repeat until complete

### Step 5: Complete

After all tasks complete and verified, run the full quality suite:

```bash
mix check
```

Report the final output and confirm everything passes.

## When to Stop and Ask for Help

**STOP immediately when:**

- A test fails and the fix is unclear
- Plan has a gap that prevents starting the next task
- An instruction is ambiguous
- A dependency is missing or incompatible

**Ask for clarification rather than guessing.**

## Remember

- Review the plan critically before touching code
- Follow plan steps exactly — don't skip steps
- Don't run `mix check` until all tasks are done; run individual checks per batch
- Between batches: report and wait for feedback
- Stop when blocked; don't guess

---
name: apply-code-standards
description: Expert in code design standards. ALWAYS use when designing modules, implementing features, fixing bugs, or refactoring. Orchestrates SOLID-equivalent, clean code, and Elixir idiom principles.
---

# Code Standards Guide

Write well-designed, maintainable Elixir without over-engineering.

## When to Use

Engage proactively when:

- Designing new contexts, modules, or behaviours
- Implementing features or Oban workers
- Refactoring existing code
- Fixing bugs that reveal structural problems
- Something feels too complex — or suspiciously over-engineered

## Core Philosophy

1. **Start simple, refactor when the pattern becomes clear** — don't create abstractions before you have 3+ real uses
2. **Duplication over wrong abstraction** — two similar functions in different contexts may be coincidental; wait
3. **KISS over DRY** — a clear 10-line function beats a clever 3-line one
4. **YAGNI always** — build what the current requirement needs; Elixir's refactoring cost is low

## Skill Delegation

| Situation | Use Skill |
|---|---|
| Designing module boundaries, behaviours, context APIs | `apply-solid-principles` |
| Preventing over-engineering, applying KISS/YAGNI/DRY | `use-code-patterns` |
| Writing or renaming functions | `write-self-documenting-code` |
| Adding comments or `@doc` | `when-to-document` |

## When to Apply Principles

### Apply When:

- Business logic that will evolve (contexts, workers, transformers)
- Multiple implementations of the same concept (e.g., different API adapters)
- Testability is critical (Oban workers, context functions)
- Long-term maintainability matters

### Don't Over-Apply When:

- Simple CRUD context functions
- One-off Mix tasks
- Prototypes in a documentation livebook
- Adding complexity without a concrete benefit today

## Elixir-Specific Anti-Patterns to Avoid

**Context that does too much:**

```elixir
# ❌ Beatseek.Artists doing verification, scanning, AND notifications
defmodule Beatseek.Artists do
  def scan_and_verify_and_notify(path), do: ...
end

# ✅ Each context owns its concern; orchestration belongs in a worker
defmodule Beatseek.Scanner do
  def scan(path), do: ...
end
defmodule Beatseek.Verification.Spotify do
  def verify(artist_id), do: ...
end
```

**Premature abstraction:**

```elixir
# ❌ Building a generic "transformer framework" for two transformers
defmodule Beatseek.Transformers.Base do
  @callback transform(map()) :: map()
  def run(transformer, data), do: transformer.transform(data)
end

# ✅ Just call the transformer directly — you have two of them
ArtistTransformer.transform(id3_tag)
```

**Clever pipelines that obscure intent:**

```elixir
# ❌ Hard to debug; what does step 3 produce?
result = input |> step1() |> step2() |> step3() |> step4() |> step5()

# ✅ Name intermediate results when the shape changes
parsed = step1(input)
filtered = step2(parsed)
Albums.upsert_many(filtered)
```

## Quick Validation Checklist

Before finalising code:

**Simplicity:**

- [ ] Simplest solution that solves the actual requirement (KISS)
- [ ] No speculative features or configurable knobs (YAGNI)
- [ ] Abstraction only introduced after 3+ identical occurrences (DRY)

**Design:**

- [ ] Module has one clear reason to change (SRP)
- [ ] Business logic in a context or worker, not in LiveView or controller
- [ ] Functions under ~20 lines; deeply nested `case`/`cond` extracted

**Pragmatism:**

- [ ] Principles aren't adding complexity on a simple problem
- [ ] Another developer could follow this without a walkthrough

## Remember

- **Quality over dogma** — principles serve the code, not the other way around
- **Readability over cleverness** — Elixir pattern matching is expressive; use it to clarify, not impress
- **Simple problems deserve simple solutions** — a plain `if` is fine

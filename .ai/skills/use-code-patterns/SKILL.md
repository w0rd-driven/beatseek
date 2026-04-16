---
name: use-code-patterns
description: Apply KISS, YAGNI, DRY, and Tell-Don't-Ask principles when writing Elixir. Use proactively to prevent over-engineering and maintain simplicity.
---

# How to Apply Clean Code Principles in Elixir

These principles prevent over-engineering. Apply them as guardrails whenever you write code.

## The Golden Rule

**When in doubt, choose the simpler solution.** Complexity is a cost you pay forever.

---

## KISS — Keep It Simple, Stupid

Before adding any abstraction, ask: *"Is this the simplest solution that works?"*

```elixir
# ❌ Built for flexibility nobody asked for
defmodule Beatseek.Scanner do
  defstruct [:strategy, :filter_pipeline, :dedup_resolver]

  def scan(%__MODULE__{strategy: strategy} = config, path) do
    strategy.discover(path)
    |> apply_filters(config.filter_pipeline)
    |> resolve_duplicates(config.dedup_resolver)
  end
end

# ✅ Write this — you can always refactor when complexity arrives
defmodule Beatseek.Scanner do
  def scan(directory \\ config_directory()) do
    Path.wildcard(Path.join(directory, "/**/*.mp3"))
    |> Enum.uniq_by(&Path.dirname/1)
    |> Enum.map(&parse_and_upsert/1)
  end
end
```

**Apply KISS by:**

- Starting with the most direct implementation
- Avoiding behaviours and protocols until you have multiple real implementations
- Preferring plain functions over modules with state
- Asking "would another developer follow this without a walkthrough?"

---

## YAGNI — You Aren't Gonna Need It

Build only what the current requirement needs. Delete speculative code.

```elixir
# ❌ Built "just in case" — don't write these yet
defmodule Beatseek.Artists do
  def upsert_artist(params), do: ...         # needed today
  def upsert_artists_batch(list), do: ...    # not needed yet
  def upsert_artist_with_retry(params), do: ... # not needed yet
  def upsert_artist_async(params), do: ...   # not needed yet
end

# ✅ Build only what you need today
defmodule Beatseek.Artists do
  def upsert_artist(params) do
    %Artist{}
    |> Artist.changeset(params)
    |> Repo.insert(on_conflict: {:replace, [:name, :updated_at]}, conflict_target: :spotify_id)
  end
end
```

**Catch yourself violating YAGNI when you think:**

- "We might need this for Spotify pagination later"
- "It would be easy to make this configurable while I'm here"
- "What if we add another music API?"

The correct response: build it when the requirement actually arrives. Elixir's refactoring cost is low.

---

## DRY — Don't Repeat Yourself (Rule of Three)

Wait for **three occurrences** before abstracting. Premature abstraction is worse than duplication.

```elixir
# First occurrence — write it inline
def transform_for_artist(%{artist: name}), do: %{name: name}

# Second occurrence — copy it; note the duplication but don't extract yet
def transform_for_album(%{artist: name, album: title}), do: %{artist_name: name, title: title}

# Third occurrence — NOW consider extracting
defp extract_artist_name(%{artist: name}), do: name
```

**Before extracting shared code, verify:**

- [ ] This exact logic appears 3+ times
- [ ] The occurrences are truly identical, not just similar
- [ ] They should change together (same business reason)
- [ ] The extraction is clearer than the duplication

**Don't apply DRY when:**

- Code looks similar but represents different domain concepts (artist transformer vs. Spotify transformer)
- Abstracting would create coupling between unrelated contexts
- You only have 1–2 occurrences

---

## Tell, Don't Ask (TDA) in Elixir

In OOP, TDA means "tell objects what to do rather than extracting their data to decide". In Elixir (where data is immutable), this principle translates to: **put behaviour in the module that owns the data shape**.

```elixir
# ❌ Asking for data in LiveView, deciding elsewhere
def handle_event("verify", %{"id" => id}, socket) do
  artist = Artists.get_artist!(id)
  if is_nil(artist.verified_at) do    # LiveView is making a domain decision
    Workers.VerificationWorker.enqueue(id)
  end
  {:noreply, socket}
end

# ✅ The context owns the decision
def handle_event("verify", %{"id" => id}, socket) do
  Artists.enqueue_verification_if_needed(id)  # Context decides
  {:noreply, socket}
end

# In Beatseek.Artists context:
def enqueue_verification_if_needed(id) do
  artist = get_artist!(id)
  if needs_verification?(artist) do
    %{id: id} |> Workers.VerificationWorker.new() |> Oban.insert()
  end
end

defp needs_verification?(%Artist{verified_at: nil}), do: true
defp needs_verification?(%Artist{verified_at: ts}),
  do: DateTime.diff(DateTime.utc_now(), ts, :day) > @freshness_days
```

**Apply TDA by:**

- Putting domain decisions in context modules, not in LiveView `handle_event/3`
- Putting data validation in changesets, not in the caller
- Putting Oban enqueueing logic in the context that owns the data

---

## When Principles Conflict

**KISS vs DRY**: Choose KISS. Duplication is cheaper than the wrong abstraction.

**YAGNI vs "Future-Proofing"**: Choose YAGNI. Build it when you actually need it.

**SOLID vs KISS**: Use SOLID when complexity justifies it. A simple context function doesn't need a behaviour module.

**TDA vs Simple Pipelines**: Data transformation pipelines (scanners, transformers) naturally expose data at each step. Apply TDA to domain decision points, not pipeline steps.

---

## Red Flags You're Over-Engineering

Stop and simplify when you notice:

- Defining a behaviour for a single implementation
- Passing a module as a parameter when there's no test stub yet
- Making something configurable when there's exactly one configuration
- Building abstractions before the third real use case
- Adding function parameters "in case someone needs them"

## Quick Checklist

- [ ] Simplest solution that solves the actual requirement (KISS)
- [ ] Only built what's needed right now (YAGNI)
- [ ] Abstracted only after 3+ identical occurrences (DRY)
- [ ] Domain decisions live in context modules, not LiveView (TDA)
- [ ] Another developer could follow this without help

## Related Skills

- `apply-solid-principles` — When to apply module boundaries and behaviours
- `apply-code-standards` — Balancing all principles together
- `write-self-documenting-code` — Naming things well

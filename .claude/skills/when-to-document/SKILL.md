---
name: when-to-document
description: When and how to add meaningful Elixir documentation. Use after exhausting self-documenting code techniques.
---

# When to Add Documentation

After making code self-documenting (see `write-self-documenting-code`), some things still need comments or `@doc`. Document these specific situations.

## Document the WHY, Not the WHAT

Comments explain **why** the code exists, not **what** it does.

```elixir
# ❌ WHAT — the code already says this
amount_in_cents = amount * 100  # Multiply by 100

# ✅ WHY — explains the non-obvious reason
# Spotify's API returns popularity as an integer 0–100, not a percentage
normalized_popularity = raw_score / 100.0
```

---

## 1. Document Complex Business Rules in `@doc`

When a function has multiple conditions or non-obvious tiers, use `@doc` to explain the rule.

```elixir
@doc """
Determines whether an artist needs verification against Spotify.

An artist is considered stale and needs re-verification if:
- They have never been verified (`verified_at` is nil), OR
- Their last verification was more than #{@verification_freshness_days} days ago

Albums added during a previous verification are preserved; only missing
albums from the Spotify catalogue trigger new notifications.
"""
def needs_verification?(%Artist{verified_at: nil}), do: true
def needs_verification?(%Artist{verified_at: ts}) do
  DateTime.diff(DateTime.utc_now(), ts, :day) > @verification_freshness_days
end
```

**When to add business rule `@doc`:**

- Multiple conditional branches based on business rules
- Thresholds or time windows that came from a product decision
- Edge cases that aren't obvious from pattern matching alone

---

## 2. Document Non-Obvious Performance Decisions

When code looks wrong but is intentional, explain why.

```elixir
# Intentionally deduplicating by directory before parsing ID3 tags.
# A single album folder can contain dozens of MP3 files; parsing one
# per directory is sufficient to extract artist/album metadata and
# reduces parse time by ~95% on large collections.
Path.wildcard(path)
|> Enum.uniq_by(&Path.dirname/1)
|> Enum.map(&parse_first_track/1)
```

---

## 3. Document Workarounds and Hacks

When working around a bug or external limitation, document it with a ticket reference.

```elixir
# WORKAROUND: spotify_ex returns {:ok, %{"error" => ...}} (not {:error, _})
# for expired tokens instead of the expected {:error, :unauthorized}.
# We pattern-match on the error body until spotify_ex is fixed.
# Tracked in: https://github.com/w0rd-driven/beatseek/issues/XX
case Spotify.AuthRequest.post(params) do
  {:ok, %{"error" => _} = err} -> {:error, err}
  {:ok, response} -> {:ok, response}
end
```

**Include in workaround comments:**

- What the workaround addresses
- Why it's necessary
- Link to the issue or ticket tracking the fix

---

## 4. Document External API Quirks

When integrating with external systems, document their requirements in `@moduledoc` or `@doc`.

```elixir
@moduledoc """
Spotify API client for artist and album verification.

Rate limits: ~100 requests per 30 seconds. The `VerificationWorker`
uses a #{@backfill_delay_seconds}-second delay between backfill jobs
to stay within these limits.

The Search API returns up to 50 results per query. If an artist has
more than 50 albums, some may be missed. Spotify does not provide a
dedicated "get all albums for artist" endpoint without user OAuth.

Authentication uses client credentials (not user OAuth), so only
publicly available catalogue data is accessible.
"""
defmodule Beatseek.Verification.Spotify do
```

---

## 5. Document `{:error, reason}` Return Values

When a function can fail in multiple ways with different reasons, document them in `@doc`.

```elixir
@doc """
Fetches and updates artist image from Spotify.

Returns:
- `{:ok, artist}` on success
- `{:error, :not_found}` if Spotify returns no matching artists
- `{:error, :auth_failed}` if client credentials are invalid or expired
- `{:error, :rate_limited}` if Spotify rate limit is exceeded
"""
@spec get_artist(integer()) :: {:ok, Artist.t()} | {:error, :not_found | :auth_failed | :rate_limited}
def get_artist(id), do: ...
```

---

## 6. Document Migration Design Decisions

In Ecto migrations, explain why columns exist or why decisions were made.

```elixir
create table(:albums) do
  # year stored as string to preserve "2003" vs "2003-04-08" — Spotify
  # returns only the year for some older releases
  add :year, :string

  # image_url populated by verification step, not the initial scan;
  # nil means the artist/album has not been verified against Spotify yet
  add :image_url, :string

  # Composite unique index — the same album name can exist for different artists
  add :artist_id, references(:artists, on_delete: :delete_all), null: false
end

create unique_index(:albums, [:artist_id, :name])
```

---

## Quick Reference: Document or Not?

| Situation | Document? |
|---|---|
| What the code does | No — rename it |
| Complex business rule or threshold | Yes — `@doc` |
| Why code looks "wrong" | Yes — inline comment |
| Workaround for a bug | Yes — inline comment + issue link |
| External API quirk or rate limit | Yes — `@moduledoc` or `@doc` |
| `{:error, reason}` variants a caller must handle | Yes — `@doc` |
| Obvious code | No — delete the comment |

## Related Skills

- `write-self-documenting-code` — Make code explain itself first
- `documentation-best-practices` — Full guide including `@doc`, `@moduledoc`, `@spec`

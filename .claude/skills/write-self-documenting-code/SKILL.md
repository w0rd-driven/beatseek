---
name: write-self-documenting-code
description: Write Elixir code that doesn't need comments. Use when naming functions/modules/variables or when tempted to add a comment.
---

# How to Write Self-Documenting Elixir Code

The best documentation is code that doesn't need documentation. Before adding a comment, make the code explain itself.

## Rule 1: Replace Comments with Better Names

When you want a comment explaining what code does, rename the thing instead.

```elixir
# ❌ Comment explains what the code does
def calc(u, items) do
  # Check if user is VIP
  d = if u.vip, do: 0.10, else: 0.0
  # Apply discount to total
  Enum.sum(items) * (1 - d)
end

# ✅ Names explain themselves — no comments needed
def calculate_discounted_total(%User{} = customer, items) do
  discount_rate = if customer.is_vip, do: 0.10, else: 0.0
  Enum.sum(items) * (1 - discount_rate)
end
```

**Naming checklist:**

- [ ] Can I understand this without the comment?
- [ ] Does the name describe what, not how?
- [ ] Would a new developer understand this?

---

## Rule 2: Extract Complex Conditions into Named Functions

When a condition needs a comment, extract it into a well-named private function.

```elixir
# ❌ Comment needed to explain the guard
if !is_nil(artist.verified_at) and
   DateTime.diff(DateTime.utc_now(), artist.verified_at, :day) < 30 do
  # Skip recently verified artists
  :skip
end

# ✅ Function name IS the explanation
if recently_verified?(artist) do
  :skip
end

defp recently_verified?(%Artist{verified_at: nil}), do: false
defp recently_verified?(%Artist{verified_at: ts}) do
  DateTime.diff(DateTime.utc_now(), ts, :day) < 30
end
```

---

## Rule 3: Use `@spec` Instead of Commenting Types

When you want to document what a parameter or return value looks like, add a typespec.

```elixir
# ❌ What does this return? What's in the map?
def transform(data) do
  # Returns a map with :name and :image_url keys
  ...
end

# ✅ @spec makes it self-documenting
@spec transform(map()) :: %{name: String.t(), image_url: String.t() | nil}
def transform(%{} = id3_tag) do
  ...
end
```

---

## Rule 4: Use Structs for Domain Concepts

When a plain map is being passed around with implicit keys, make it a struct.

```elixir
# ❌ What keys does this map have? Who knows?
def upsert_artist(params) when is_map(params), do: ...

# ✅ Struct documents the shape — callers know exactly what's expected
defmodule Beatseek.Artists.ArtistParams do
  @enforce_keys [:name]
  defstruct [:name, :image_url, :spotify_id]
end

def upsert_artist(%ArtistParams{} = params), do: ...
```

---

## Rule 5: Use Module Attributes for Magic Values

When a number or string appears without context, extract it to a named module attribute.

```elixir
# ❌ What does 30 mean? Why 1?
if DateTime.diff(now, artist.verified_at, :day) < 30 do
  %{id: next_id, backfill: true}
  |> new(schedule_in: 1)
  |> Oban.insert()
end

# ✅ Attributes explain the business rule
@verification_freshness_days 30
@backfill_delay_seconds 1

if DateTime.diff(now, artist.verified_at, :day) < @verification_freshness_days do
  %{id: next_id, backfill: true}
  |> new(schedule_in: @backfill_delay_seconds)
  |> Oban.insert()
end
```

---

## Delete These Comments

Remove comments that state the obvious:

```elixir
# ❌ These add no value — delete them

# Get the artist from the database
def get_artist!(id), do: Repo.get!(Artist, id)

# Transform the ID3 tag into artist params
def transform(id3_tag) do
  # Build the map
  %{name: id3_tag.artist, image_url: nil}
end

artist = Artists.get_artist!(id)  # Get artist by id
```

---

## Quick Checklist

Before adding a comment, try:

- [ ] Better function/variable/module name?
- [ ] Extract condition to a named private function?
- [ ] Add `@spec` type annotation?
- [ ] Use a struct instead of a plain map?
- [ ] Extract constant to a module attribute?

If none of these work, the comment is probably legitimate. See `when-to-document`.

## Related Skills

- `when-to-document` — When comments ARE needed
- `documentation-best-practices` — Full documentation guide including `@doc` and `@moduledoc`

---
name: documentation-best-practices
description: Write meaningful Elixir documentation using @doc, @moduledoc, and @spec. Orchestrates self-documenting code and when-to-document skills.
---

# Documentation Best Practices

Keep documentation minimal and meaningful. The best documentation is code that doesn't need it.

## The Documentation Decision Tree

```
Do I need to add documentation?
│
├─ Can I rename to make it clear? → YES, rename instead
│
├─ Can I extract a well-named private function? → YES, extract instead
│
├─ Can I add a @spec? → YES, add the typespec instead
│
├─ Is this a business rule, workaround, or external API quirk? → YES, document WHY
│
└─ Is the comment stating the obvious? → NO, delete it
```

## Skill Delegation

| Question | Use Skill |
|---|---|
| How do I make code self-explanatory? | `write-self-documenting-code` |
| When should I add comments or `@doc`? | `when-to-document` |

## Core Principles

1. **Document WHY, not WHAT** — code shows what; `@doc` explains why
2. **Make code self-documenting first** — better names beat better comments
3. **Keep documentation close to the code** — update `@doc` when the function changes
4. **Delete obsolete comments immediately** — wrong comments are worse than none

---

## Elixir Documentation Tools

### `@moduledoc`

Use for module-level context: what this module is responsible for, its main public API surface, and any important external dependencies or quirks.

```elixir
@moduledoc """
Scans a local MP3 directory, parses ID3 tags, and upserts
artists and albums into the database.

Reads from the `SCAN_DIRECTORY` env var (configured via
`Beatseek.Scanner.config_directory/0`). Only the first MP3
in each directory is parsed — album-level metadata is consistent
across tracks in a folder.
"""
defmodule Beatseek.Scanner do
```

Skip `@moduledoc` when:
- The module name fully explains its purpose (`Beatseek.Transformers.ArtistTransformer`)
- It's a small private helper with one exported function

### `@doc`

Use for public functions with non-obvious behaviour, complex return values, or important business rules.

```elixir
@doc """
Verifies an artist against the Spotify catalogue and creates
notifications for any missing albums.

Returns a list of `:ok | {:error, reason}` tuples — one per album
processed. Partial failures are isolated; one bad album does not
stop the rest from being processed.
"""
def verify(artist_id), do: ...
```

Skip `@doc` when:
- The function name and `@spec` fully describe the contract
- It's a private function (`defp`)

### `@spec`

Use for all public context and worker functions. It replaces type-explaining comments.

```elixir
@spec upsert_artist(map()) :: {:ok, Artist.t()} | {:error, Ecto.Changeset.t()}
def upsert_artist(params), do: ...

@spec get_artist!(integer()) :: Artist.t()  # raises if not found
def get_artist!(id), do: Repo.get!(Artist, id)
```

### Inline comments

Reserve for:
- Workarounds with a ticket link
- Non-obvious performance decisions
- External API quirks not worth a full `@doc`

---

## Quick Checklist

Before committing documentation:

- [ ] Tried making code self-documenting first?
- [ ] `@doc` / inline comments explain WHY, not WHAT?
- [ ] No obvious or redundant comments?
- [ ] `@spec` added for public functions?
- [ ] Workarounds include an issue link?
- [ ] `@moduledoc` explains the module's responsibility, not its implementation?

## Related Skills

- `write-self-documenting-code` — How to write code that explains itself
- `when-to-document` — Specific situations that need comments or `@doc`

---
name: apply-solid-principles
description: Apply SOLID-equivalent design principles when designing Elixir modules, behaviours, and context boundaries. Use when creating new modules or refactoring existing ones.
---

# How to Apply SOLID Principles in Elixir

SOLID principles originated in OOP but map well onto Elixir's module system and behaviours. Work through each principle when designing or refactoring.

## Before Writing Any Module

Ask:

1. **Can I describe this module without "and"?** If not, split it (SRP)
2. **Will I need to modify this code to add a new implementation?** If yes, define a behaviour (OCP)
3. **Can any module implementing this behaviour be swapped in transparently?** If not, fix the contract (LSP)
4. **Are there callbacks this implementation doesn't use?** If yes, split the behaviour (ISP)
5. **Am I calling a concrete module I could abstract?** If yes, depend on a behaviour instead (DIP)

---

## Single Responsibility Principle (SRP)

**One module, one reason to change.** In Beatseek, this means:

```elixir
# ❌ Scanner doing ID3 parsing, DB writes, AND Spotify verification
defmodule Beatseek.Scanner do
  def scan_and_sync(path) do
    parse_id3(path)
    |> upsert_to_db()
    |> verify_against_spotify()  # Wrong layer
  end
end

# ✅ Each module owns one concern
defmodule Beatseek.Scanner do
  def scan(path), do: ...       # Parse ID3, upsert to DB
end
defmodule Beatseek.Verification.Spotify do
  def verify(artist_id), do: ... # Spotify API + missing album detection
end
defmodule Beatseek.Workers.VerificationWorker do
  def perform(%{args: %{"id" => id}}), do: ... # Orchestrates verification
end
```

**Apply SRP when:**

- A module has multiple unrelated private functions
- Tests for one feature break when you change another
- You describe the module with "it does X and also Y"

---

## Open/Closed Principle (OCP)

**Open for extension, closed for modification.** In Elixir, use `@behaviour` so new implementations don't require editing existing code.

```elixir
# ❌ Adding a new notification channel means editing this function
defmodule Beatseek.Notifications.Delivery do
  def deliver(album, :email), do: send_email(album)
  def deliver(album, :slack), do: send_slack(album)
  # To add :sms, you must edit this module
end

# ✅ Define a behaviour; each channel is an independent module
defmodule Beatseek.Notifications.Channel do
  @callback deliver(album :: map()) :: :ok | {:error, term()}
end

defmodule Beatseek.Notifications.EmailChannel do
  @behaviour Beatseek.Notifications.Channel
  def deliver(album), do: ...
end

# Adding SMS = new module, no edits to existing modules
defmodule Beatseek.Notifications.SmsChannel do
  @behaviour Beatseek.Notifications.Channel
  def deliver(album), do: ...
end
```

**Apply OCP when:**

- You have `case type do :a -> ... :b -> ... end` on a "kind" of thing
- Adding a new variant requires editing existing, working code
- You anticipate multiple implementations (API adapters, notification channels)

---

## Liskov Substitution Principle (LSP)

**Any module implementing a behaviour must be substitutable for any other.** Callers must not be surprised.

```elixir
# ❌ This implementation raises where the behaviour doesn't promise it
defmodule Beatseek.Verification.MockSpotify do
  @behaviour Beatseek.Verification.Client
  def get_artist(_id), do: raise "Not implemented"  # Caller can't substitute this safely
end

# ✅ Honour the contract: return the same tuple shapes
defmodule Beatseek.Verification.MockSpotify do
  @behaviour Beatseek.Verification.Client
  def get_artist(_id), do: {:ok, %{name: "Test Artist", image_url: nil}}
  def get_albums(_artist), do: {:ok, []}
end
```

**Check LSP by asking:**

- Does the implementation raise exceptions the behaviour doesn't document?
- Does it return `nil` or different tuple shapes than other implementations?
- Can tests substitute it for the real module without changing test setup?

---

## Interface Segregation Principle (ISP)

**Don't force modules to implement callbacks they don't need.** Keep behaviours focused.

```elixir
# ❌ A read-only cache adapter is forced to implement write callbacks
defmodule Beatseek.Storage do
  @callback get(key :: String.t()) :: {:ok, term()} | :error
  @callback put(key :: String.t(), value :: term()) :: :ok
  @callback delete(key :: String.t()) :: :ok
  @callback list_all() :: [term()]
end

# ✅ Split into focused behaviours
defmodule Beatseek.Storage.Readable do
  @callback get(key :: String.t()) :: {:ok, term()} | :error
  @callback list_all() :: [term()]
end

defmodule Beatseek.Storage.Writable do
  @callback put(key :: String.t(), value :: term()) :: :ok
  @callback delete(key :: String.t()) :: :ok
end
```

**Apply ISP when:**

- An implementing module has callbacks that raise `{:error, :not_implemented}`
- Different callers need only a subset of a behaviour's callbacks
- You're grouping unrelated operations in one behaviour for convenience

---

## Dependency Inversion Principle (DIP)

**Depend on behaviours (abstractions), not concrete modules.** This is how you keep contexts testable.

```elixir
# ❌ Hard-coded dependency; can't test without real Spotify API
defmodule Beatseek.Verification.Spotify do
  def verify(artist_id) do
    conn = Spotify.AuthRequest.post(...)  # Direct Spotify call
    ...
  end
end

# ✅ Inject the API client; tests pass a stub
defmodule Beatseek.Verification do
  def verify(artist_id, client \\ Beatseek.Verification.SpotifyClient) do
    client.get_artist(artist_id)
    |> client.get_albums()
    ...
  end
end

# In tests:
Beatseek.Verification.verify(artist_id, FakeSpotifyClient)
```

**Elixir patterns for DIP:**

- Pass the module as a parameter with a default (above)
- Configure via `Application.get_env(:beatseek, :spotify_client, SpotifyClient)`
- Use `Mox` in tests to define stubs against a behaviour

---

## Quick Reference Checklist

Before committing a module:

- [ ] Can describe it without "and" (SRP)
- [ ] New variants don't require editing this code (OCP)
- [ ] Any implementation can substitute another (LSP)
- [ ] No module implements unused callbacks (ISP)
- [ ] Business logic depends on behaviours, not concrete modules (DIP)

## Related Skills

- `use-code-patterns` — KISS, YAGNI, DRY guardrails
- `apply-code-standards` — when to balance principles vs. pragmatism
- `wrap-in-transactions` — keeping multi-step operations atomic

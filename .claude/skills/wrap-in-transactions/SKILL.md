---
name: wrap-in-transactions
description: Wrap multi-write Ecto operations in Ecto.Multi transactions; use PubSub broadcasts after commit and idempotency patterns for consistency.
---

# Transactions and Consistency in Ecto

Ensure multi-step database changes are atomic; make retries safe.

## The Pattern

```elixir
alias Ecto.Multi

Multi.new()
|> Multi.insert(:artist, Artist.changeset(%Artist{}, artist_params))
|> Multi.insert(:album, fn %{artist: artist} ->
  Album.changeset(%Album{}, Map.put(album_params, :artist_id, artist.id))
end)
|> Repo.transaction()
|> case do
  {:ok, %{artist: artist, album: album}} ->
    # Broadcast AFTER commit — DB is consistent before side effects
    BeatseekWeb.Endpoint.broadcast!("album", "created", album)
    {:ok, album}

  {:error, _operation, changeset, _changes_so_far} ->
    {:error, changeset}
end
```

## When to Use `Ecto.Multi`

- Creating a parent record and one or more children atomically (artist + album)
- Updating multiple records that must all succeed or all roll back
- Any operation where partial success would leave the DB in an inconsistent state

## When a Simple `Repo.transaction/1` Is Enough

For simpler cases without named steps:

```elixir
Repo.transaction(fn ->
  artist = Repo.insert!(%Artist{name: name})
  Repo.insert!(%Album{artist_id: artist.id, name: album_name})
  artist
end)
```

Use `Ecto.Multi` when you need to reference earlier results or want named error reporting.

## PubSub: Broadcast After Commit

Never broadcast a PubSub event inside the transaction. Broadcast after `Repo.transaction/1` succeeds:

```elixir
# ❌ Broadcasting inside the transaction — DB might still roll back
Repo.transaction(fn ->
  {:ok, album} = Albums.create_album(params)
  BeatseekWeb.Endpoint.broadcast!("album", "created", album)  # Too early
end)

# ✅ Broadcast after the transaction confirms
case Repo.transaction(multi) do
  {:ok, %{album: album}} ->
    BeatseekWeb.Endpoint.broadcast!("album", "created", album)
    {:ok, album}
  {:error, _, changeset, _} ->
    {:error, changeset}
end
```

## Oban Jobs: Insert After Commit

When an Oban job depends on data written in a transaction, use `Oban.insert/2` after the transaction commits — not inside it.

```elixir
case Repo.transaction(multi) do
  {:ok, %{artist: artist}} ->
    %{id: artist.id}
    |> Beatseek.Workers.VerificationWorker.new()
    |> Oban.insert()

    {:ok, artist}

  {:error, _, changeset, _} ->
    {:error, changeset}
end
```

## Idempotency

Make writes safe to retry. Use `on_conflict` in `Repo.insert/2`:

```elixir
Repo.insert(
  Artist.changeset(%Artist{}, params),
  on_conflict: {:replace, [:name, :image_url, :updated_at]},
  conflict_target: :spotify_id,
  returning: true
)
```

For upserts that should be no-ops on conflict:

```elixir
Repo.insert(changeset, on_conflict: :nothing, conflict_target: :spotify_id)
```

## Row-Level Locking

When two processes might update the same artist concurrently:

```elixir
from(a in Artist, where: a.id == ^id, lock: "FOR UPDATE")
|> Repo.one()
```

Use sparingly — only when you have a documented race condition.

## Validate Before Starting

Run validation at the boundary before opening a transaction. Don't use a transaction to discover invalid data:

```elixir
# ✅ Validate the changeset first, open DB connection only if valid
with {:ok, _} <- validate_params(params),
     {:ok, result} <- Repo.transaction(build_multi(params)) do
  {:ok, result}
end
```

## Related Skills

- `apply-code-standards` — When to apply patterns vs. keeping it simple
- `create-migrations` — Schema changes that accompany new write operations

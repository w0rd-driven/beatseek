defmodule Beatseek.Albums do
  @moduledoc """
  The Albums context.
  """

  import Ecto.Query, warn: false
  alias Beatseek.Repo

  alias Beatseek.Albums.Album

  @doc """
  Returns the list of albums.

  ## Examples

      iex> list_albums()
      [%Album{}, ...]

  """
  def list_albums do
    query =
      from album in Album,
        join: artist in assoc(album, :artist),
        order_by: [asc: artist.name, asc: album.year]

    Repo.all(query)
    |> Repo.preload(:artist)
  end

  @doc """
  Returns the list of albums by artist.

  ## Examples

      iex> list_albums_by_artist()
      [%Album{}, ...]

  """
  def list_albums_by_artist(artist) do
    Album
    |> where([album], album.artist_id == ^artist.id)
    |> order_by([album], asc: :year)
    |> Repo.all()
  end

  @doc """
  Gets a single album.

  Raises `Ecto.NoResultsError` if the Album does not exist.

  ## Examples

      iex> get_album!(123)
      %Album{}

      iex> get_album!(456)
      ** (Ecto.NoResultsError)

  """
  def get_album!(id), do: Repo.get!(Album, id) |> Repo.preload(:artist)

  @doc """
  Gets a single album by name and artist_id.

  ## Examples

      iex> get_artist_album_by_name("Periphery")
      {:ok, %Album{}}

      iex> get_artist_album_by_name("Baby Shark")
      {:error, Ecto.NoResultsError}

  """
  def get_artist_album_by_name(name, artist_id) do
    search = "%#{name}%"

    Album
    |> where([album], ilike(album.name, ^search))
    |> where([album], album.artist_id == ^artist_id)
    |> Repo.all()
    |> Repo.preload(:artist)
    |> Enum.at(0)
  end

  @doc """
  Creates a album.

  ## Examples

      iex> create_album(%{field: value})
      {:ok, %Album{}}

      iex> create_album(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_album(attrs \\ %{}) do
    %Album{}
    |> Album.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a artist.

  ## Examples

      iex> create_artist(%{field: value})
      {:ok, %Artist{}}

      iex> create_artist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def upsert_album(attrs \\ %{}, artist \\ nil) do
    %Album{}
    |> Album.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:artist, artist)
    |> Repo.insert(
      on_conflict: {:replace_all_except, [:id]},
      conflict_target: [:artist_id, :name]
    )
  end

  @doc """
  Updates a album.

  ## Examples

      iex> update_album(album, %{field: new_value})
      {:ok, %Album{}}

      iex> update_album(album, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_album(%Album{} = album, attrs) do
    album
    |> Album.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a album.

  ## Examples

      iex> delete_album(album)
      {:ok, %Album{}}

      iex> delete_album(album)
      {:error, %Ecto.Changeset{}}

  """
  def delete_album(%Album{} = album) do
    Repo.delete(album)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking album changes.

  ## Examples

      iex> change_album(album)
      %Ecto.Changeset{data: %Album{}}

  """
  def change_album(%Album{} = album, attrs \\ %{}) do
    Album.changeset(album, attrs)
  end

  @doc """
  Returns a count of owned vs total albums.

  ## Examples

      iex> get_album_counts()
      {0, 0}

  """
  def get_album_counts do
    owned = Album
    |> where([album], album.is_owned)
    |> Repo.aggregate(:count, :id)
    total = Album
    |> Repo.aggregate(:count, :id)
    {owned, total}
  end
end

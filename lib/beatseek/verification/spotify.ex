defmodule Beatseek.Verification.Spotify do
  alias Beatseek.Artists
  alias Beatseek.Transformers.SpotifyAlbumTransformer
  alias Spotify.Search
  alias Spotify.Album

  def verify(artist_id) do
    get_artist_by_id(artist_id)
    |> get_artist_albums_by_spotify_id()
  end

  def get_artist_by_id(artist_id) do
    artist = Artists.get_artist!(artist_id)
    get_artist_id(artist.name)
  end

  def authenticate(params \\ %{grant_type: "client_credentials"}) do
    with {:ok, response} <- Spotify.AuthRequest.post(URI.encode_query(params)) do
      parsed_response = response.body |> Jason.decode!()
      Spotify.Credentials.get_tokens_from_response(parsed_response)
    end
  end

  def get_artist_id(name) do
    conn = authenticate()
    {:ok, %{items: items}} = Search.query(conn, q: name, type: "artist", market: "US")
    [head | _] = items
    %{conn: conn, spotify_id: head.id}
  end

  def get_artist_albums_by_spotify_id(%{conn: conn, spotify_id: spotify_id}) do
    IO.inspect(spotify_id, label: "Spotify ID")
    {:ok, albums} = Album.get_artists_albums(conn, spotify_id)
    albums
  end

  def search_artist(artist_id) do
    artist = Artists.get_artist!(artist_id)
    search_albums(artist.name)
  end

  def search_albums(name) do
    conn = authenticate()
    {:ok, %{items: items}} = Search.query(conn, q: name, type: "artist", market: "US")
    [head | _] = items
    spotify_id = head.id
    {:ok, %{items: items}} = Search.query(conn, q: name, type: "album", market: "US")

    items
    |> Enum.filter(&(&1.album_type == "album"))
    |> Enum.filter(fn album ->
      album.artists |> Enum.any?(&(&1["id"] == spotify_id))
    end)
    |> Enum.map(&(SpotifyAlbumTransformer.transform/1))
    |> Enum.uniq(&(&1.name))
  end
end

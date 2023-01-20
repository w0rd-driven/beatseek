defmodule Beatseek.Verification.Spotify do
  alias Beatseek.Artists
  alias Spotify.Search

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
      parsed_response = response.body |> Jason.decode!() |> IO.inspect(label: "Spotify JSON")
      Spotify.Credentials.get_tokens_from_response(parsed_response)
    end
  end

  def get_artist_id(name) do
    IO.inspect(name, label: "Artist Name")
    conn = authenticate()
    {:ok, %{items: items}} = Search.query(conn, q: name, type: "artist", market: "US")
    [head | _] = items
    head
  end

  def get_artist_albums_by_spotify_id(spotify_id) do
    IO.inspect(spotify_id, label: "Spotify ID")
  end
end

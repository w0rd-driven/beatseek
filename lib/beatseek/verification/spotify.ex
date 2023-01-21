defmodule Beatseek.Verification.Spotify do
  alias Beatseek.Artists
  alias Beatseek.Albums
  alias Beatseek.Transformers.SpotifyAlbumTransformer
  alias Spotify.Search

  def verify(id) do
    get_artist(id)
    |> get_albums()
    |> add_missing_albums()
  end

  def get_artist(id) do
    conn = authenticate()
    artist = Artists.get_artist!(id)
    {:ok, %{items: items}} = Search.query(conn, q: artist.name, type: "artist", market: "US")
    [head | _] = items
    spotify_id = head.id
    {conn, artist, spotify_id}
  end

  def get_albums({conn, artist, spotify_id}) do
    {:ok, %{items: items}} = Search.query(conn, q: artist.name, type: "album", market: "US")

    albums =
      items
      |> Enum.filter(&(&1.album_type == "album"))
      |> Enum.filter(fn album ->
        album.artists |> Enum.any?(&(&1["id"] == spotify_id))
      end)
      |> Enum.map(&SpotifyAlbumTransformer.transform/1)
      |> Enum.uniq(& &1.name)

    %{artist: artist, albums: albums}
  end

  def add_missing_albums(%{artist: artist, albums: albums} = _map) do
    albums
    |> Enum.map(fn album_params ->
      find_existing(album_params, artist)
      |> create_if_missing()
      |> send_notification()
    end)
  end

  def find_existing(album_params, artist) do
    case Albums.get_artist_album_by_name(album_params.name, artist.id) do
      album ->
        is_nil(album) || Albums.update_album(album, %{image_url: album_params[:image_url]})
        {album, album_params, artist}
      nil ->
        {nil, album_params, artist}
    end
  end

  def create_if_missing({album, params, artist}) when is_nil(album) do
    params = params |> Map.put(:artist_id, artist.id)

    case Albums.create_album(params) do
      {:ok, record} ->
        BeatseekWeb.Endpoint.broadcast!("albums", "new", record)
        record
      {:error, _} -> nil
    end
  end

  def create_if_missing({_album, _params, _artist}), do: nil

  def send_notification(album) when is_nil(album), do: :ok

  def send_notification(album) do
    Beatseek.Notifications.Delivery.deliver(album)
  end

  def authenticate(params \\ %{grant_type: "client_credentials"}) do
    with {:ok, response} <- Spotify.AuthRequest.post(URI.encode_query(params)) do
      parsed_response = response.body |> Jason.decode!()
      Spotify.Credentials.get_tokens_from_response(parsed_response)
    end
  end
end

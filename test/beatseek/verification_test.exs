defmodule Beatseek.VerificationTest do
  use Beatseek.DataCase, async: true

  alias Beatseek.Transformers.SpotifyAlbumTransformer

  import Beatseek.ArtistsFixtures
  import Beatseek.SpotifyFixtures

  defp create_artist(_) do
    attrs = %{name: "Periphery"}
    artist = artist_fixture(attrs)
    %{artist: artist}
  end

  defp create_spofity_conn(attrs \\ %{}) do
    conn = spotify_credential_fixture(attrs)
    %{conn: conn}
  end

  defp create_spotify_artist(attrs \\ %{}) do
    artist = spotify_artist_fixture(attrs)
    %{artist: artist}
  end

  defp create_spotify_albums(attrs \\ %{}) do
    %{artist: artist} = create_spotify_artist()
    album = spotify_album_fixture(attrs) |> SpotifyAlbumTransformer.transform()
    albums = [album]

    %{artist: artist, albums: albums}
  end

  describe "Spotify verify/1" do
    test "" do
    end
  end

  describe "Spotify get_artist/1" do
    setup [:create_artist]

    test "returns the artist from Spotify with a valid id", %{artist: artist} do
      expected_artist = artist
      %{conn: expected_conn} = create_spofity_conn()
      %{artist: expected_spotify_artist} = create_spotify_artist()
      {actual_conn, actual_artist, actual_spotify_artist} = Beatseek.Verification.Spotify.get_artist(artist.id)

      assert actual_artist.id == expected_artist.id
      assert actual_artist.name == expected_artist.name

      assert actual_spotify_artist.name == expected_spotify_artist.name
      assert actual_spotify_artist.id == expected_spotify_artist.id
      assert actual_spotify_artist.type == expected_spotify_artist.type

      assert actual_conn.refresh_token == expected_conn.refresh_token
    end
  end

  describe "Spotify get_albums/1" do
    setup [:create_artist]

    test "returns the artist albums from Spotify with valid arguments", %{artist: artist} do
      expected_artist = artist
      %{artist: _, albums: expected_albums} = create_spotify_albums()

      arguments = Beatseek.Verification.Spotify.get_artist(artist.id)
      %{artist: actual_artist, albums: actual_albums} = Beatseek.Verification.Spotify.get_albums(arguments)

      assert actual_artist.id == expected_artist.id
      assert actual_artist.name == expected_artist.name

      expected_album = Enum.at(expected_albums, 0)

      actual_album =
        Enum.find(actual_albums, fn album ->
          album.name == expected_album.name
        end)

      assert actual_album.image_url == expected_album.image_url
      assert actual_album.name == expected_album.name
      assert actual_album.release_date == expected_album.release_date
      assert actual_album.year == expected_album.year
    end
  end

  describe "Spotify add_missing_albums/1" do
    test "add albums that do not exist locally and send a notification for each" do
    end
  end
end

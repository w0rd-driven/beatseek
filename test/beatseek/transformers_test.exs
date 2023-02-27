defmodule Beatseek.TransformersTest do
  use Beatseek.DataCase, async: true

  alias Beatseek.Transformers.SpotifyAlbumTransformer
  alias Beatseek.Transformers.SpotifyArtistTransformer
  alias Beatseek.Transformers.ArtistTransformer
  alias Beatseek.Transformers.AlbumTransformer
  import Beatseek.MP3FileFixtures
  import Beatseek.SpotifyFixtures

  defp create_artist(_) do
    artist = artist_fixture()
    %{artist: artist}
  end

  defp create_album(_) do
    album = album_fixture()
    %{album: album}
  end

  defp create_spotify_artist(_) do
    artist = spotify_artist_fixture()
    %{artist: artist}
  end

  defp create_spotify_album(_) do
    album = spotify_album_fixture()
    %{album: album}
  end

  describe "ArtistTransformer transform/1" do
    setup [:create_artist]

    test "a valid id3 tag returns a map", %{artist: artist} do
      assert ArtistTransformer.transform(artist) == %{
               name: "Periphery",
               path: "/Users/jbrayton/Music/iTunes/iTunes Media/Music/Periphery"
             }
    end
  end

  describe "AlbumTransformer.transform/1" do
    setup [:create_album]

    test "a valid id3 tag returns a map", %{album: album} do
      assert AlbumTransformer.transform(album) == %{
               name: "Periphery",
               path: "/Users/jbrayton/Music/iTunes/iTunes Media/Music/Periphery/Periphery",
               genre: "Progressive Metal / Math Metal / Djent",
               is_owned: true,
               year: "2010"
             }
    end
  end

  describe "AlbumTransformer.transform/2" do
    test "setting is_owned to false is reflected in the output" do
      album = album_fixture()

      assert AlbumTransformer.transform(album, false) == %{
               name: "Periphery",
               path: "/Users/jbrayton/Music/iTunes/iTunes Media/Music/Periphery/Periphery",
               genre: "Progressive Metal / Math Metal / Djent",
               is_owned: false,
               year: "2010"
             }
    end
  end

  describe "SpotifyArtistTransformer.transform/1" do
    setup [:create_spotify_artist]

    test "a valid Spotify Artist returns a map", %{artist: artist} do
      assert SpotifyArtistTransformer.transform(artist) == %{
               image_url: "https://i.scdn.co/image/ab67616100005174ae2304891734b9d9fafe1c8d"
             }
    end
  end

  describe "SpotifyAlbumTransformer.transform/1" do
    setup [:create_spotify_album]

    test "a valid Spotify Album returns a map", %{album: album} do
      assert SpotifyAlbumTransformer.transform(album) == %{
               image_url: "https://i.scdn.co/image/ab67616d00001e0276c5a9aa980d3a43eaa19583",
               name: "Periphery",
               release_date: "2010-04-20",
               year: "2010"
             }
    end
  end
end

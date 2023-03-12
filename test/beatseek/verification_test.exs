defmodule Beatseek.VerificationTest do
  use Beatseek.DataCase, async: true
  @moduletag :integration

  alias Beatseek.Transformers.SpotifyAlbumTransformer

  import Beatseek.ArtistsFixtures
  import Beatseek.NotificationsFixtures
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

  defp create_notification(_attrs \\ %{}) do
    attrs = %{
      subject: "Periphery released Periphery V: Djent Is Not A Genre on Friday, March 10, 2023.",
      type: :album_new_release
    }

    notification = notification_fixture(attrs)
    %{notification: notification}
  end

  defp assert_notifications(actual_notifications) do
    %{notification: expected_notification} = create_notification()

    actual_notification =
      Enum.find(actual_notifications, fn notification ->
        notification.subject == expected_notification.subject
      end)

    assert actual_notification.subject == expected_notification.subject
    assert actual_notification.type == expected_notification.type
  end

  describe "Spotify verify/1" do
    setup [:create_artist]

    test "returns the list of notifications sent", %{artist: artist} do
      actual_notifications = Beatseek.Verification.Spotify.verify(artist.id)
      assert_notifications(actual_notifications)
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
    setup [:create_artist]

    test "add albums that do not exist locally and send a notification for each", %{artist: artist} do
      arguments = Beatseek.Verification.Spotify.get_artist(artist.id)
      albums = Beatseek.Verification.Spotify.get_albums(arguments)
      actual_notifications = Beatseek.Verification.Spotify.add_missing_albums(albums)
      assert_notifications(actual_notifications)
    end
  end
end

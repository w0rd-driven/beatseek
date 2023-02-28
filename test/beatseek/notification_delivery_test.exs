defmodule Beatseek.NotificationDeliveryTest do
  use Beatseek.DataCase, async: true

  import Beatseek.ArtistsFixtures
  import Beatseek.AlbumsFixtures

  defp create_album(_) do
    artist = artist_fixture()
    album = album_fixture(artist_id: artist.id) |> Beatseek.Repo.preload(:artist, force: true)
    %{album: album}
  end

  describe "deliver/1" do
    setup [:create_album]

    test "a valid album creates a notification and broadcasts the new record", %{album: album} do
      BeatseekWeb.Endpoint.subscribe("notification")

      expected = %{
        album_id: album.id,
        subject: "some name released some name"
      }

      actual = Beatseek.Notifications.Delivery.deliver(album)

      assert actual.subject =~ expected[:subject]
      assert actual.type == :album_not_owned
      assert_receive %{topic: "notification", event: "new"}
    end
  end

  describe "deliver/2" do
    test "sender and type creates a notification and broadcasts the new record" do
      BeatseekWeb.Endpoint.subscribe("notification")

      expected = %{
        subject: "Periphery released Periphery II",
        type: "album_not_owned"
      }

      actual = Beatseek.Notifications.Delivery.deliver(expected[:subject], expected[:type])

      assert actual.subject == expected[:subject]
      assert actual.type == :album_not_owned
      assert_receive %{topic: "notification", event: "new"}
    end
  end

  # TODO: This is purely for debugging so I'm pretty lazy with implementing assertions for 9 notifications
  # describe "deliver_dummy/0" do
  #   test "creates and broadcasts a group of test notifications" do
  #   end
  # end

  describe "get_attributes_from_album/1" do
    setup [:create_album]

    test "a valid album returns a map of valid attributes", %{album: album} do
      expected = %{
        album_id: album.id,
        subject: "#{album.artist.name} released #{album.name}"
      }

      actual = Beatseek.Notifications.Delivery.get_attributes_from_album(album)

      assert actual[:album_id] == expected[:album_id]
      assert actual[:subject] =~ expected[:subject]
    end
  end

  describe "send_app_notification/1" do
    test "valid attributes creates a notification and broadcasts the new record" do
      BeatseekWeb.Endpoint.subscribe("notification")

      expected = %{
        subject: "Periphery released Periphery II",
        type: "album_new_release"
      }

      Beatseek.Notifications.Delivery.send_app_notification(expected)

      assert_receive %{topic: "notification", event: "new"}
    end

    test "invalid attributes raises an Ecto.CastError" do
      assert_raise Ecto.CastError, fn ->
        Beatseek.Notifications.Delivery.send_app_notification(nil)
      end
    end
  end
end

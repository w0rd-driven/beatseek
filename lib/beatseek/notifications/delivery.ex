defmodule Beatseek.Notifications.Delivery do
  alias Beatseek.Albums.Album

  def deliver() do
    notification_from_album()
  end

  def notification_from_album() do
    album_not_owned = %{
      subject: "This is a new not_owned notification",
      type: "album_not_owned"
    }

    album_new_release = %{
      subject: "This is a new new_release notification",
      type: "album_new_release"
    }

    album_upcoming_release = %{
      subject: "This is a new upcoming_release notification",
      type: "album_upcoming_release"
    }

    Enum.map(1..3, fn index ->
      app_notification(album_not_owned)
      app_notification(album_new_release)
      app_notification(album_upcoming_release)
    end)
  end

  def app_notification(attributes \\ %{}) do
    {:ok, notification} = Beatseek.Notifications.create_notification(attributes)

    # I see why we keep this tied to the web. It's better to alias business logic in the web than the other way around
    #   I'm kind of stuck here though because something would always call into that. I need to send a pubsub event triggered
    #   from this layer. I don't see a way around that.
    BeatseekWeb.Endpoint.broadcast!("notifications", "new", notification)
  end
end

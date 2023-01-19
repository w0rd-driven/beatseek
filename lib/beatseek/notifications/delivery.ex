defmodule Beatseek.Notifications.Delivery do
  alias Beatseek.Albums.Album

  def deliver() do
    notification_from_album()
  end

  def notification_from_album() do
    not_owned = %{
      subject: "This is a new not_owned notification",
      type: "not_owned"
    }

    new_release = %{
      subject: "This is a new new_release notification",
      type: "new_release"
    }

    upcoming_release = %{
      subject: "This is a new upcoming_release notification",
      type: "upcoming_release"
    }

    Enum.map(1..3, fn index ->
      app_notification(not_owned)
      app_notification(new_release)
      app_notification(upcoming_release)
    end)
  end

  def app_notification(attributes) do
    {:ok, notification} = Beatseek.Notifications.create_notification(attributes)

    # I see why we keep this tied to the web. It's better to alias business logic in the web than the other way around
    #   I'm kind of stuck here though because something would always call into that. I need to send a pubsub event triggered
    #   from this layer.
    BeatseekWeb.Endpoint.broadcast!("notifications", "new", notification)
  end
end

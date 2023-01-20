defmodule Beatseek.Notifications.Delivery do
  alias Beatseek.Notifications

  def deliver(album) do
    get_attributes_from_album(album)
    |> send_app_notification()
  end

  def deliver(subject, type) do
    %{subject: subject, type: type}
    |> send_app_notification()
  end

  def deliver_dummy() do
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

    Enum.map(1..3, fn _index ->
      send_app_notification(album_not_owned)
      send_app_notification(album_new_release)
      send_app_notification(album_upcoming_release)
    end)
  end

  def get_attributes_from_album(album) do
    case Timex.parse(album.release_date, "{YYYY}-{0M}-{0D}") do
      {:ok, datetime} ->
        release_date = datetime |> NaiveDateTime.to_date()
        today = NaiveDateTime.utc_now() |> NaiveDateTime.to_date()
        humanized_date = Timex.format!(release_date, "%A, %B %d, %Y", :strftime)
        interval = Timex.Interval.new(from: release_date, until: today)

        type =
          case Timex.Interval.duration(interval, :months) do
            months when months < 0 -> "album_upcoming_release"
            months when months <= 6 -> "album_new_release"
            months when months > 7 -> "album_not_owned"
            _ -> nil
          end

        attributes = %{
          album_id: album.id,
          subject: "#{album.name} was released on #{humanized_date}.",
          type: type
        }

      {:error, _} ->
        %{}
    end
  end

  def send_app_notification(attributes) do
    {:ok, notification} = Notifications.create_notification(attributes)

    # I see why we keep this tied to the web. It's better to alias business logic in the web than the other way around
    #   I'm kind of stuck here though because something would always call into that. I need to send a pubsub event triggered
    #   from this layer. I don't see a way around that.
    BeatseekWeb.Endpoint.broadcast!("notifications", "new", notification)
  end
end

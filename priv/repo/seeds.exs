# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Beatseek.Repo.insert!(%Beatseek.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Notifications
alias Beatseek.Notifications

album_not_owned = %{
  subject: "This is a new album_not_owned notification",
  type: "album_not_owned"
}

album_new_release = %{
  subject: "This is a new album_new_release notification",
  type: "album_new_release"
}

album_upcoming_release = %{
  subject: "This is a new album_upcoming_release notification",
  type: "album_upcoming_release"
}

Enum.map(1..3, fn index ->
  Notifications.create_notification(album_not_owned)
  Notifications.create_notification(album_new_release)
  Notifications.create_notification(album_upcoming_release)
end)

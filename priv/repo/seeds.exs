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

Notifications.create_notification(not_owned)
Notifications.create_notification(new_release)
Notifications.create_notification(upcoming_release)

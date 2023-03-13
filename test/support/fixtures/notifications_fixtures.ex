defmodule Beatseek.NotificationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Beatseek.Notifications` context.
  """

  @doc """
  Generate a notification.
  """
  def notification_fixture(attrs \\ %{}) do
    {:ok, notification} =
      attrs
      |> Enum.into(%{
        body: "some body",
        icon: "some icon",
        subject: "some subject",
        type: :album_not_owned,
        url: "some url"
      })
      |> Beatseek.Notifications.create_notification()

    notification
  end
end

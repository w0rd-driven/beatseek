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
        seen_at: ~U[2023-01-16 08:41:00.000000Z],
        subject: "some subject",
        type: "some type",
        url: "some url"
      })
      |> Beatseek.Notifications.create_notification()

    notification
  end
end

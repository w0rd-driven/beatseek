defmodule BeatseekWeb.NotificationLiveTest do
  use BeatseekWeb.ConnCase

  import Phoenix.LiveViewTest
  import Beatseek.NotificationsFixtures

  defp create_notification(_) do
    notification = notification_fixture()
    %{notification: notification}
  end

  describe "Index" do
    setup [:create_notification]

    test "lists all notifications", %{conn: conn, notification: notification} do
      {:ok, _index_live, html} = live(conn, ~p"/notifications")

      assert html =~ "Notifications"
      assert html =~ notification.subject
    end

    test "deletes notification in listing", %{conn: conn, notification: notification} do
      {:ok, index_live, _html} = live(conn, ~p"/notifications")

      assert index_live
             |> element("#notification-#{notification.id} div a")
             |> render_click()

      refute has_element?(index_live, "#notification-#{notification.id}")
    end
  end

  describe "Show" do
    setup [:create_notification]

    test "displays notification", %{conn: conn, notification: notification} do
      {:ok, _show_live, html} = live(conn, ~p"/notifications/#{notification}")

      assert html =~ "Show Notification"
      assert html =~ notification.subject
    end
  end
end

defmodule BeatseekWeb.NotificationLiveTest do
  use BeatseekWeb.ConnCase

  import Phoenix.LiveViewTest
  import Beatseek.NotificationsFixtures

  @create_attrs %{
    body: "some body",
    icon: "some icon",
    seen_at: "2023-01-16T08:41:00.000000Z",
    subject: "some subject",
    type: "some type",
    url: "some url"
  }
  @update_attrs %{
    body: "some updated body",
    icon: "some updated icon",
    seen_at: "2023-01-17T08:41:00.000000Z",
    subject: "some updated subject",
    type: "some updated type",
    url: "some updated url"
  }
  @invalid_attrs %{body: nil, icon: nil, seen_at: nil, subject: nil, type: nil, url: nil}

  defp create_notification(_) do
    notification = notification_fixture()
    %{notification: notification}
  end

  describe "Index" do
    setup [:create_notification]

    test "lists all notifications", %{conn: conn, notification: notification} do
      {:ok, _index_live, html} = live(conn, ~p"/notifications")

      assert html =~ "Listing Notifications"
      assert html =~ notification.body
    end

    test "saves new notification", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/notifications")

      assert index_live |> element("a", "New Notification") |> render_click() =~
               "New Notification"

      assert_patch(index_live, ~p"/notifications/new")

      assert index_live
             |> form("#notification-form", notification: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#notification-form", notification: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/notifications")

      assert html =~ "Notification created successfully"
      assert html =~ "some body"
    end

    test "updates notification in listing", %{conn: conn, notification: notification} do
      {:ok, index_live, _html} = live(conn, ~p"/notifications")

      assert index_live
             |> element("#notifications-#{notification.id} a", "Edit")
             |> render_click() =~
               "Edit Notification"

      assert_patch(index_live, ~p"/notifications/#{notification}/edit")

      assert index_live
             |> form("#notification-form", notification: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#notification-form", notification: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/notifications")

      assert html =~ "Notification updated successfully"
      assert html =~ "some updated body"
    end

    test "deletes notification in listing", %{conn: conn, notification: notification} do
      {:ok, index_live, _html} = live(conn, ~p"/notifications")

      assert index_live
             |> element("#notifications-#{notification.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#notification-#{notification.id}")
    end
  end

  describe "Show" do
    setup [:create_notification]

    test "displays notification", %{conn: conn, notification: notification} do
      {:ok, _show_live, html} = live(conn, ~p"/notifications/#{notification}")

      assert html =~ "Show Notification"
      assert html =~ notification.body
    end

    test "updates notification within modal", %{conn: conn, notification: notification} do
      {:ok, show_live, _html} = live(conn, ~p"/notifications/#{notification}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Notification"

      assert_patch(show_live, ~p"/notifications/#{notification}/show/edit")

      assert show_live
             |> form("#notification-form", notification: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#notification-form", notification: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/notifications/#{notification}")

      assert html =~ "Notification updated successfully"
      assert html =~ "some updated body"
    end
  end
end

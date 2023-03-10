defmodule Beatseek.NotificationsTest do
  use Beatseek.DataCase, async: true

  alias Beatseek.Notifications

  describe "notifications" do
    alias Beatseek.Notifications.Notification

    import Beatseek.NotificationsFixtures

    @invalid_attrs %{body: nil, icon: nil, seen_at: nil, subject: nil, type: nil, url: nil}

    test "list_notifications/0 returns all notifications" do
      notification = notification_fixture()
      assert Notifications.list_notifications() == [notification]
    end

    test "get_notification!/1 returns the notification with given id" do
      notification = notification_fixture()
      assert Notifications.get_notification!(notification.id) == notification
    end

    test "create_notification/1 with valid data creates a notification" do
      valid_attrs = %{
        body: "some body",
        icon: "some icon",
        seen_at: ~U[2023-01-16 08:41:00.000000Z],
        subject: "some subject",
        type: :album_not_owned,
        url: "some url"
      }

      assert {:ok, %Notification{} = notification} = Notifications.create_notification(valid_attrs)

      assert notification.body == "some body"
      assert notification.icon == "some icon"
      assert notification.seen_at == ~U[2023-01-16 08:41:00.000000Z]
      assert notification.subject == "some subject"
      assert notification.type == :album_not_owned
      assert notification.url == "some url"
    end

    test "create_notification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notifications.create_notification(@invalid_attrs)
    end

    test "update_notification/2 with valid data updates the notification" do
      notification = notification_fixture()

      update_attrs = %{
        body: "some updated body",
        icon: "some updated icon",
        seen_at: ~U[2023-01-17 08:41:00.000000Z],
        subject: "some updated subject",
        type: :album_new_release,
        url: "some updated url"
      }

      assert {:ok, %Notification{} = notification} = Notifications.update_notification(notification, update_attrs)

      assert notification.body == "some updated body"
      assert notification.icon == "some updated icon"
      assert notification.seen_at == ~U[2023-01-17 08:41:00.000000Z]
      assert notification.subject == "some updated subject"
      assert notification.type == :album_new_release
      assert notification.url == "some updated url"
    end

    test "update_notification/2 with invalid data returns error changeset" do
      notification = notification_fixture()

      assert {:error, %Ecto.Changeset{}} = Notifications.update_notification(notification, @invalid_attrs)

      assert notification == Notifications.get_notification!(notification.id)
    end

    test "delete_notification/1 deletes the notification" do
      notification = notification_fixture()
      assert {:ok, %Notification{}} = Notifications.delete_notification(notification)
      assert_raise Ecto.NoResultsError, fn -> Notifications.get_notification!(notification.id) end
    end

    test "change_notification/1 returns a notification changeset" do
      notification = notification_fixture()
      assert %Ecto.Changeset{} = Notifications.change_notification(notification)
    end
  end
end

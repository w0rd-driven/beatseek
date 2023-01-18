defmodule BeatseekWeb.NotificationLive.Index do
  use BeatseekWeb, :live_view

  alias Beatseek.Notifications
  alias Beatseek.Notifications.Notification

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:notifications, list_unseen_notifications())
     |> assign(:active_tab, :notifications)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Notification")
    |> assign(:notification, Notifications.get_notification!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Notification")
    |> assign(:notification, %Notification{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Notifications")
    |> assign(:notification, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    notification = Notifications.get_notification!(id)
    {:ok, _} = Notifications.mark_notification_as_seen(notification)

    {:noreply, assign(socket, :notifications, list_unseen_notifications())}
  end

  defp list_unseen_notifications do
    Notifications.list_unseen_notifications()
  end
end

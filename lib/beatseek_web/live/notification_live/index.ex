defmodule BeatseekWeb.NotificationLive.Index do
  use BeatseekWeb, :live_view

  alias Beatseek.Notifications
  alias Beatseek.Notifications.Notification

  @topic "notification"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      BeatseekWeb.Endpoint.subscribe(@topic)
    end

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

    BeatseekWeb.Endpoint.broadcast!(@topic, "seen", notification)

    {:noreply, assign(socket, :notifications, list_unseen_notifications())}
  end

  @impl true
  def handle_info(%{topic: @topic, event: "new", payload: payload} = _message, socket) do
    notifications = [payload | socket.assigns.notifications]
    {:noreply, assign(socket, :notifications, notifications)}
  end

  @impl true
  def handle_info(%{topic: @topic, event: "seen"} = _message, socket) do
    {:noreply, socket}
  end

  defp list_unseen_notifications do
    Notifications.list_unseen_notifications()
  end
end

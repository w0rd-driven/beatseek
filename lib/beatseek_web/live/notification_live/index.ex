defmodule BeatseekWeb.NotificationLive.Index do
  use BeatseekWeb, :live_view

  alias Beatseek.Notifications
  alias Beatseek.Notifications.Notification

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :notifications, list_notifications())}
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
    |> assign(:page_title, "Listing Notifications")
    |> assign(:notification, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    notification = Notifications.get_notification!(id)
    {:ok, _} = Notifications.delete_notification(notification)

    {:noreply, assign(socket, :notifications, list_notifications())}
  end

  defp list_notifications do
    Notifications.list_notifications()
  end
end

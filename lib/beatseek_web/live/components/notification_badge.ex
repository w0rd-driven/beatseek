defmodule BeatseekWeb.Components.NotificationBadge do
  use BeatseekWeb, :live_component

  alias Beatseek.Notifications

  @topic "notifications"

  @impl true
  def mount(socket) do
    count = 0
    {:ok, socket |> assign(count: count)}
  end

  @impl true
  def update(_assigns, socket) do
    {:ok, socket |> assign(count: Notifications.get_unseen_notification_count())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <span class="flex items-center justify-center text-sm text-red-400 font-bold bg-primary-200 h-6 px-2 rounded-full ml-auto">
      <%= @count %>
    </span>
    """
  end
end

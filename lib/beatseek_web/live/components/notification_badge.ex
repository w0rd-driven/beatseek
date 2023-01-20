defmodule BeatseekWeb.Components.NotificationBadge do
  use BeatseekWeb, :live_component

  alias Beatseek.Notifications

  @impl true
  def mount(socket) do
    count = Notifications.get_unseen_notification_count()
    {:ok, socket |> assign(count: count)}
  end

  @impl true
  def update(assigns, socket) do
    count =
      case assigns do
        %{action: :increment} -> socket.assigns.count + 1
        %{action: :decrement} -> socket.assigns.count - 1
        _ -> socket.assigns.count
      end

    {:ok, socket |> assign(count: count)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <span class="flex items-center justify-center text-sm text-red-600 font-black bg-primary-200 h-6 px-2 rounded-full ml-auto">
      <%= @count %>
    </span>
    """
  end
end

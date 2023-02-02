defmodule BeatseekWeb.Components.NotificationBadge do
  use Phoenix.Component

  attr :id, :string
  attr :owned, :integer, default: 0
  attr :total, :integer, default: 0

  def notification_badge(assigns) do
    ~H"""
    <span class="flex items-center justify-center text-sm font-black bg-primary-200 text-red-600 rounded-full h-6 px-2 ml-auto">
      <%= @count %>
    </span>
    """
  end
end

defmodule BeatseekWeb.Components.AlbumBadge do
  use Phoenix.Component

  attr :id, :string
  attr :owned, :integer, default: 0
  attr :total, :integer, default: 0

  def album_badge(assigns) do
    ~H"""
    <span class="flex items-center justify-center text-sm font-black bg-primary-200 text-primary-900 rounded-full h-6 px-2 ml-auto">
      <%= @owned %> / <%= @total %>
    </span>
    """
  end
end

defmodule BeatseekWeb.Components.ArtistBadge do
  use Phoenix.Component

  attr :id, :string
  attr :owned, :integer, default: 0
  attr :total, :integer, default: 0

  def artist_badge(assigns) do
    ~H"""
    <span class="flex items-center justify-center text-sm font-black bg-primary-200 text-primary-900 rounded-full h-6 px-2 ml-auto">
      <%= @count %>
    </span>
    """
  end
end

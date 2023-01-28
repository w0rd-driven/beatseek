defmodule BeatseekWeb.Components.AlbumBadge do
  use BeatseekWeb, :live_component

  alias Beatseek.Albums

  @impl true
  def mount(socket) do
    {owned, total} = Albums.get_album_counts()
    {:ok, socket |> assign(owned: owned) |> assign(total: total)}
  end

  @impl true
  def update(assigns, socket) do
    total =
      case assigns do
        %{action: :increment} -> socket.assigns.total + 1
        %{action: :decrement} -> socket.assigns.total - 1
        _ -> socket.assigns.total
      end

    {:ok, socket |> assign(total: total)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <span class="flex items-center justify-center text-sm font-black bg-primary-200 text-primary-900 rounded-full h-6 px-2 ml-auto">
      <%= @owned %> / <%= @total %>
    </span>
    """
  end
end

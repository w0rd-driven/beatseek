defmodule BeatseekWeb.Components.ArtistBadge do
  use BeatseekWeb, :live_component

  alias Beatseek.Artists

  @impl true
  def mount(socket) do
    count = Artists.get_artist_count()
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
    <span class="flex items-center justify-center text-sm font-black bg-primary-200 text-primary-900 rounded-full h-6 px-2 ml-auto">
      <%= @count %>
    </span>
    """
  end
end

defmodule BeatseekWeb.Components.NotificationBadge do
  use BeatseekWeb, :live_component

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(count: 0)}
  end

  @impl true
  def update(assigns, socket) do
    # TODO Get count from Database
    {:ok, socket |> assign(count: 1000)}
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

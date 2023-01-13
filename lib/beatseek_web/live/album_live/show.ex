defmodule BeatseekWeb.AlbumLive.Show do
  use BeatseekWeb, :live_view

  alias Beatseek.Albums

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:album, Albums.get_album!(id))}
  end

  defp page_title(:show), do: "Show Album"
  defp page_title(:edit), do: "Edit Album"
end

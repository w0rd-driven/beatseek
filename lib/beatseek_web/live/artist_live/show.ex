defmodule BeatseekWeb.ArtistLive.Show do
  use BeatseekWeb, :live_view

  alias Beatseek.Artists
  alias Beatseek.Albums
  import BeatseekWeb.Components.AlbumArt

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:active_tab, :artists)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    artist = Artists.get_artist!(id)
    albums = list_albums_by_artist(artist)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:artist, artist)
     |> assign(:albums, albums)
     |> assign(:album_count, Enum.count(albums))}
  end

  defp page_title(:show), do: "Show Artist"
  defp page_title(:edit), do: "Edit Artist"

  def show_dropdown(to) do
    JS.show(
      to: to,
      transition:
        {"transition ease-out duration-120", "transform opacity-0 scale-95", "transform opacity-100 scale-100"}
    )
    |> JS.set_attribute({"aria-expanded", "true"}, to: to)
  end

  def hide_dropdown(to) do
    JS.hide(
      to: to,
      transition: {"transition ease-in duration-120", "transform opacity-100 scale-100", "transform opacity-0 scale-95"}
    )
    |> JS.remove_attribute("aria-expanded", to: to)
  end

  @impl true
  def handle_event("verify", %{"id" => id}, socket) do
    artist = Artists.get_artist!(id)
    attrs = %{verified_at: nil}
    {:ok, _} = Beatseek.Artists.update_artist(artist, attrs)
    Beatseek.Workers.VerificationWorker.new(%{id: id, backfill: true}) |> Oban.insert!()
    {:noreply, socket}
  end

  defp list_albums_by_artist(artist) do
    Albums.list_albums_by_artist(artist)
  end
end

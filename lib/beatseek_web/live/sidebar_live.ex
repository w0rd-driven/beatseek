defmodule BeatseekWeb.SidebarLive do
  use BeatseekWeb, :live_view

  alias Beatseek.Artists
  import BeatseekWeb.Components.ArtistBadge

  alias Beatseek.Albums
  import BeatseekWeb.Components.AlbumBadge

  alias Beatseek.Notifications
  import BeatseekWeb.Components.NotificationBadge

  @artist_topic "artist"
  @album_topic "album"
  @notification_topic "notification"

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
      BeatseekWeb.Endpoint.subscribe(@artist_topic)
      BeatseekWeb.Endpoint.subscribe(@album_topic)
      BeatseekWeb.Endpoint.subscribe(@notification_topic)
    end

    %{"active_tab" => active_tab, "current_user" => current_user} = session

    artist_count = Artists.get_artist_count()
    {albums_owned, albums_total} = Albums.get_album_counts()
    notifications_count = Notifications.get_unseen_notification_count()

    socket =
      socket
      |> assign(:active_tab, active_tab)
      |> assign(:current_user, current_user)
      |> assign(:artist_count, artist_count)
      |> assign(:albums_owned, albums_owned)
      |> assign(:albums_total, albums_total)
      |> assign(:notifications_count, notifications_count)

    {:ok, socket, layout: false}
  end

  attr :id, :string
  attr :active_tab, :atom

  @impl true
  def render(assigns) do
    ~H"""
    <ul class="flex flex-col sticky top-0 w-full min-w-md">
      <li class="my-px mx-auto pt-4">
        <.link navigate={~p"/"} class="group px-4 text-primary-600 flex flex-row relative">
          <span class="absolute left-4">
            <Heroicons.signal solid class="h-10 w-10 stroke-current" />
          </span>
          <span class="text-secondary-400 absolute left-4">
            <Heroicons.signal solid class="h-10 w-10 stroke-current animate-ping" />
          </span>
          <span class="text-secondary-400 absolute left-4 rotate-90">
            <Heroicons.signal solid class="h-10 w-10 stroke-current animate-ping" />
          </span>
          <h1 class="font-logo text-4xl pl-10 italic tracking-tighter -rotate-1">Beatseek</h1>
        </.link>
      </li>
      <li class="my-px flex flex-row justify-between">
        <div class="font-bold text-md text-primary-900 px-4 mt-8 mb-4 uppercase">Music</div>
        <button
          id="music_menu"
          type="button"
          class="group bg-neutral-400 rounded-full px-0.5 py-0.5 my-auto mt-8 text-sm text-center font-medium text-primary-600 hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-200 focus:ring-primary-600"
          phx-click={}
          phx-hook="MusicMenu"
          data-active-class="bg-gray-100"
          aria-haspopup="true"
        >
          <Heroicons.ellipsis_horizontal solid class="h-6 w-6 stroke-current" />
        </button>
      </li>
      <li class="my-px">
        <.link
          navigate={~p"/artists"}
          class={
              "group flex flex-row items-center h-12 px-4 rounded-lg text-primary-600 hover:bg-primary-200 #{if @active_tab == :artists, do: "bg-secondary-300"}"
            }
          aria-current={if @active_tab == :artists, do: "true", else: "false"}
        >
          <span class="flex items-center justify-center text-lg text-primary-400">
            <Heroicons.microphone solid class="h-6 w-6 stroke-current" />
          </span>
          <span class="ml-3 font-bold">Artists</span>
          <.artist_badge id="artistBadge" count={@artist_count} />
        </.link>
      </li>
      <li class="my-px">
        <.link
          navigate={~p"/albums"}
          class={
              "group flex flex-row items-center h-12 px-4 rounded-lg text-primary-600 hover:bg-primary-200 #{if @active_tab == :albums, do: "bg-secondary-300"}"
            }
          aria-current={if @active_tab == :albums, do: "true", else: "false"}
        >
          <span class="flex items-center justify-center text-lg text-primary-400">
            <Heroicons.rectangle_group solid class="h-6 w-6 stroke-current" />
          </span>
          <span class="ml-3 font-bold">Albums</span>
          <.album_badge id="albumBadge" owned={@albums_owned} total={@albums_total} />
        </.link>
      </li>
      <li class="my-px">
        <span class="flex font-bold text-md text-primary-900 px-4 my-4 uppercase">Account</span>
      </li>
      <li :if={!is_nil(@current_user)} class="my-px">
        <.link
          navigate={~p"/users/settings"}
          class={
              "group flex flex-row items-center h-12 px-4 rounded-lg text-primary-600 hover:bg-primary-200 #{if @active_tab == :settings, do: "bg-secondary-300"}"
            }
          aria-current={if @active_tab == :settings, do: "true", else: "false"}
        >
          <span class="flex items-center justify-center text-lg text-primary-400">
            <Heroicons.user solid class="h-6 w-6 stroke-current" />
          </span>
          <span class="ml-3 font-bold">Profile</span>
        </.link>
      </li>
      <li class="my-px">
        <.link
          navigate={~p"/notifications"}
          class={
              "group flex flex-row items-center h-12 px-4 rounded-lg text-primary-600 hover:bg-primary-200 #{if @active_tab == :notifications, do: "bg-secondary-300"}"
            }
          aria-current={if @active_tab == :notifications, do: "true", else: "false"}
        >
          <span class="flex items-center justify-center text-lg text-primary-400">
            <Heroicons.bell_alert solid class="h-6 w-6 stroke-current" />
          </span>
          <span class="ml-3 font-bold">Notifications</span>
          <.notification_badge id="notificationBadge" count={@notifications_count} />
        </.link>
      </li>
      <li :if={!is_nil(@current_user)} class="my-px">
        <a href="#" class="flex flex-row items-center h-12 px-4 rounded-lg text-primary-600 hover:bg-primary-200">
          <span class="flex items-center justify-center text-lg text-primary-400">
            <Heroicons.cog_8_tooth solid class="h-6 w-6 stroke-current" />
          </span>
          <span class="ml-3 font-bold">Settings</span>
        </a>
      </li>
      <li :if={!is_nil(@current_user)} class="my-px">
        <.link
          href={~p"/users/log_out"}
          method="delete"
          class="group flex flex-row items-center h-12 px-4 rounded-lg text-primary-600 hover:bg-primary-200"
        >
          <span class="flex items-center justify-center text-lg text-red-400">
            <Heroicons.lock_open solid class="h-6 w-6 stroke-current" />
          </span>
          <span class="ml-3 font-bold">Logout</span>
        </.link>
      </li>
    </ul>
    """
  end

  @impl true
  def handle_info(%{topic: @notification_topic, event: "new"}, socket) do
    {:noreply, update(socket, :notifications_count, &(&1 + 1))}
  end

  @impl true
  def handle_info(%{topic: @notification_topic, event: "seen"}, socket) do
    {:noreply, update(socket, :notifications_count, &(&1 - 1))}
  end

  @impl true
  def handle_info(%{topic: @artist_topic, event: "created"}, socket) do
    {:noreply, update(socket, :notifications_count, &(&1 + 1))}
  end

  @impl true
  def handle_info(%{topic: @artist_topic, event: "deleted"}, socket) do
    {:noreply, update(socket, :notifications_count, &(&1 - 1))}
  end

  @impl true
  def handle_info(%{topic: @album_topic, event: "created"}, socket) do
    {:noreply, update(socket, :albums_total, &(&1 + 1))}
  end

  @impl true
  def handle_info(%{topic: @album_topic, event: "deleted"}, socket) do
    {:noreply, update(socket, :albums_total, &(&1 - 1))}
  end
end

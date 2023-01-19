defmodule BeatseekWeb.SidebarLive do
  use BeatseekWeb, :live_view

  alias Beatseek.Notifications
  alias BeatseekWeb.Components.NotificationBadge

  @topic "notifications"

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
      BeatseekWeb.Endpoint.subscribe(@topic)
    end

    %{"active_tab" => active_tab, "current_user" => current_user} = session

    socket =
      socket
      |> assign(:active_tab, active_tab)
      |> assign(:current_user, current_user)

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
          <span class="text-secondary-200 absolute left-4 rotate-90">
            <Heroicons.signal solid class="h-10 w-10 stroke-current animate-ping" />
          </span>
          <h1 class="font-logo text-4xl pl-10 italic tracking-tighter -rotate-1">Beatseek</h1>
        </.link>
      </li>
      <li class="my-px">
        <span class="flex font-bold text-md text-primary-900 px-4 mt-8 mb-4 uppercase">Music</span>
      </li>
      <li class="my-px">
        <.link
          navigate={~p"/artists"}
          class={
              "group flex flex-row items-center h-12 px-4 rounded-lg text-primary-600 #{if @active_tab == :artists, do: "bg-gray-200", else: "hover:bg-primary-100"}"
            }
          aria-current={if @active_tab == :artists, do: "true", else: "false"}
        >
          <span class="flex items-center justify-center text-lg text-primary-400">
            <Heroicons.microphone solid class="h-6 w-6 stroke-current" />
          </span>
          <span class="ml-3 font-bold">Artists</span>
        </.link>
      </li>
      <li class="my-px">
        <.link
          navigate={~p"/albums"}
          class={
              "group flex flex-row items-center h-12 px-4 rounded-lg text-primary-600 #{if @active_tab == :albums, do: "bg-gray-200", else: "hover:bg-primary-100"}"
            }
          aria-current={if @active_tab == :albums, do: "true", else: "false"}
        >
          <span class="flex items-center justify-center text-lg text-primary-400">
            <Heroicons.rectangle_group solid class="h-6 w-6 stroke-current" />
          </span>
          <span class="ml-3 font-bold">Albums</span>
        </.link>
      </li>
      <li class="my-px">
        <span class="flex font-bold text-md text-primary-900 px-4 my-4 uppercase">Account</span>
      </li>
      <li :if={!is_nil(@current_user)} class="my-px">
        <.link
          navigate={~p"/users/settings"}
          class={
              "group flex flex-row items-center h-12 px-4 rounded-lg text-primary-600 #{if @active_tab == :settings, do: "bg-gray-200", else: "hover:bg-primary-100"}"
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
              "group flex flex-row items-center h-12 px-4 rounded-lg text-primary-600 #{if @active_tab == :notifications, do: "bg-gray-200", else: "hover:bg-primary-100"}"
            }
          aria-current={if @active_tab == :notifications, do: "true", else: "false"}
        >
          <span class="flex items-center justify-center text-lg text-primary-400">
            <Heroicons.bell_alert solid class="h-6 w-6 stroke-current" />
          </span>
          <span class="ml-3 font-bold">Notifications</span>
          <.live_component module={NotificationBadge} id="notificationBadge" />
        </.link>
      </li>
      <li :if={!is_nil(@current_user)} class="my-px">
        <a
          href="#"
          class="flex flex-row items-center h-12 px-4 rounded-lg text-primary-600 hover:bg-primary-100"
        >
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
          class="group flex flex-row items-center h-12 px-4 rounded-lg text-primary-600 hover:bg-primary-100"
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
  def handle_info(%{topic: @topic, event: "new"} = message, socket) do
    send_update(NotificationBadge,
      id: "notificationBadge",
      action: :increment
    )

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{topic: @topic, event: "seen"} = message, socket) do
    send_update(NotificationBadge,
      id: "notificationBadge",
      action: :decrement
    )

    {:noreply, socket}
  end
end

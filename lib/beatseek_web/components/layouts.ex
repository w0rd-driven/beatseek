defmodule BeatseekWeb.Layouts do
  use BeatseekWeb, :html

  alias BeatseekWeb.Components.NotificationBadge

  embed_templates "layouts/*"

  attr :id, :string
  attr :active_tab, :atom

  def sidebar(assigns) do
    ~H"""
    <div :if={!is_nil(@active_tab)} class="w-1/3 max-w-xs py-4 pr-8">
      <ul class="flex flex-col w-full sticky top-0">
        <li class="my-px">
          <span class="flex font-bold text-md text-primary-900 px-4 mt-2 mb-4 uppercase">Music</span>
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
    </div>
    """
  end

  def footer_copyright(assigns) do
    this_year = Date.utc_today().year
    assigns = assigns |> assign(:this_year, this_year)

    ~H"""
    <div class="font-medium text-lg text-primary-900">© <%= @this_year %> Jeremy Brayton</div>
    """
  end
end

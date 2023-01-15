defmodule BeatseekWeb.Layouts do
  use BeatseekWeb, :html

  embed_templates "layouts/*"

  attr :id, :string
  attr :active_tab, :atom

  def sidebar(assigns) do
    ~H"""
    <div class="flex w-full max-w-xs p-4 bg-white">
      <ul class="flex flex-col w-full">
        <li class="my-px">
          <span class="flex font-medium text-sm text-gray-400 px-4 my-4 uppercase">Music</span>
        </li>
        <li class="my-px">
          <a
            href="#"
            class="flex flex-row items-center h-12 px-4 rounded-lg text-gray-600 hover:bg-gray-100"
          >
            <span class="flex items-center justify-center text-lg text-gray-400">
              <Heroicons.microphone solid class="h-6 w-6 stroke-current" />
            </span>
            <span class="ml-3">Artists</span>
          </a>
        </li>
        <li class="my-px">
          <a
            href="#"
            class="flex flex-row items-center h-12 px-4 rounded-lg text-gray-600 hover:bg-gray-100"
          >
            <span class="flex items-center justify-center text-lg text-gray-400">
              <svg
                fill="none"
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                viewBox="0 0 24 24"
                stroke="currentColor"
                class="h-6 w-6"
              >
                <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01">
                </path>
              </svg>
            </span>
            <span class="ml-3">Albums</span>
          </a>
        </li>
        <li class="my-px">
          <span class="flex font-medium text-sm text-gray-400 px-4 my-4 uppercase">Account</span>
        </li>
        <li class="my-px">
          <a
            href="#"
            class="flex flex-row items-center h-12 px-4 rounded-lg text-gray-600 hover:bg-gray-100"
          >
            <span class="flex items-center justify-center text-lg text-gray-400">
              <Heroicons.user_circle solid class="h-6 w-6 stroke-current" />
            </span>
            <span class="ml-3">Profile</span>
          </a>
        </li>
        <li class="my-px">
          <a
            href="#"
            class="flex flex-row items-center h-12 px-4 rounded-lg text-gray-600 hover:bg-gray-100"
          >
            <span class="flex items-center justify-center text-lg text-gray-400">
              <Heroicons.bell_alert solid class="h-6 w-6 stroke-current" />
            </span>
            <span class="ml-3">Notifications</span>
            <span class="flex items-center justify-center text-sm text-red-400 font-semibold bg-gray-200 h-6 px-2 rounded-full ml-auto">
              10
            </span>
          </a>
        </li>
        <li class="my-px">
          <a
            href="#"
            class="flex flex-row items-center h-12 px-4 rounded-lg text-gray-600 hover:bg-gray-100"
          >
            <span class="flex items-center justify-center text-lg text-gray-400">
              <Heroicons.cog_8_tooth solid class="h-6 w-6 stroke-current" />
            </span>
            <span class="ml-3">Settings</span>
          </a>
        </li>
        <li class="my-px">
          <a
            href="#"
            class="flex flex-row items-center h-12 px-4 rounded-lg text-gray-600 hover:bg-gray-100"
          >
            <span class="flex items-center justify-center text-lg text-red-400">
              <Heroicons.lock_open solid class="h-6 w-6 stroke-current" />
            </span>
            <span class="ml-3">Logout</span>
          </a>
        </li>
      </ul>
    </div>
    """
  end
end

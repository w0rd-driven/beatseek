defmodule BeatseekWeb.Components.Dropdown do
  use Phoenix.Component

  attr :id, :string, required: true
  attr :name, :string

  slot :link do
    attr :navigate, :string
    attr :href, :string
    attr :method, :any
    attr :"phx-click", :any
  end

  def dropdown(assigns) do
    ~H"""
    <div class="relative inline-block text-left">
      <button
        id={@id}
        type="button"
        class="group bg-neutral-300 rounded-full px-0.5 py-0.5 my-auto mt-8 text-sm text-center font-medium text-primary-600 hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-200 focus:ring-primary-600"
        phx-click={show_dropdown("##{@id}-dropdown")}
        phx-hook="Menu"
        data-active-class="bg-gray-100"
        aria-haspopup="true"
      >
        <span class="sr-only">Open @name menu</span>
        <Heroicons.ellipsis_horizontal solid class="h-6 w-6 stroke-current" />
      </button>
      <div
        id={"#{@id}-dropdown"}
        phx-click-away={hide_dropdown("##{@id}-dropdown")}
        class="hidden absolute right-0 z-10 mt-2 w-48 origin-top-right divide-y divide-gray-100 rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none"
        role="menu"
        aria-orientation="vertical"
        aria-labelledby={@id}
        tabindex="-1"
      >
        <div class="py-1" role="none">
          <%= for link <- @link do %>
            <!-- Active: "bg-gray-100 text-gray-900", Not Active: "text-gray-700" -->
            <.link
              tabindex="-1"
              role="menuitem"
              class="block group flex items-center px-4 py-2 text-sm font-bold text-primary-900 hover:bg-primary-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-primary-200 focus:ring-primary-600"
              {link}
            >
              <%= render_slot(link) %>
            </.link>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  def show_dropdown(to) do
    Phoenix.LiveView.JS.show(
      to: to,
      transition:
        {"transition ease-out duration-120", "transform opacity-0 scale-95", "transform opacity-100 scale-100"}
    )
    |> Phoenix.LiveView.JS.set_attribute({"aria-expanded", "true"}, to: to)
  end

  def hide_dropdown(to) do
    Phoenix.LiveView.JS.hide(
      to: to,
      transition: {"transition ease-in duration-120", "transform opacity-100 scale-100", "transform opacity-0 scale-95"}
    )
    |> Phoenix.LiveView.JS.remove_attribute("aria-expanded", to: to)
  end
end

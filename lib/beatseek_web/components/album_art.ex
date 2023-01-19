defmodule BeatseekWeb.Components.AlbumArt do
  use Phoenix.Component

  attr :id, :string
  attr :class, :string, default: nil
  attr :url, :string, default: nil
  attr :is_owned, :boolean, default: false

  def album_art(assigns) do
    ~H"""
    <div class={if !@is_owned, do: "relative opacity-50", else: "relative"}>
      <img src={if is_nil(@url), do: "/images/album.svg", else: @url} class={@class} />
      <span :if={@is_owned} class="absolute bottom-0.5 right-0.5 text-supporting-teal-400">
        <Heroicons.check_badge solid class="h-6 w-6 fill-current stroke-primary-900" />
      </span>
      <span :if={!@is_owned} class="absolute bottom-0.5 right-0.5 text-secondary-400">
        <Heroicons.x_circle solid class="h-6 w-6 fill-current stroke-primary-900" />
      </span>
    </div>
    """
  end
end

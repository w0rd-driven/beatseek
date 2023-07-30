defmodule BeatseekWeb.Layouts do
  use BeatseekWeb, :html

  embed_templates "layouts/*"

  def footer_copyright(assigns) do
    this_year = Date.utc_today().year
    assigns = assigns |> assign(:this_year, this_year)

    ~H"""
    <div class="font-medium text-lg text-primary-900">© <%= @this_year %> Jeremy Brayton</div>
    """
  end
end

defmodule BeatseekWeb.ArtistLive.FormComponent do
  use BeatseekWeb, :live_component

  alias Beatseek.Artists

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage artist records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="artist-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="Name" />
        <.input field={{f, :path}} type="text" label="Path" />
        <.input field={{f, :image_url}} type="text" label="Image url" />
        <.input field={{f, :checked_at}} type="text" label="Checked at" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Artist</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{artist: artist} = assigns, socket) do
    changeset = Artists.change_artist(artist)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"artist" => artist_params}, socket) do
    changeset =
      socket.assigns.artist
      |> Artists.change_artist(artist_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"artist" => artist_params}, socket) do
    save_artist(socket, socket.assigns.action, artist_params)
  end

  defp save_artist(socket, :edit, artist_params) do
    case Artists.update_artist(socket.assigns.artist, artist_params) do
      {:ok, _artist} ->
        {:noreply,
         socket
         |> put_flash(:info, "Artist updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_artist(socket, :new, artist_params) do
    case Artists.create_artist(artist_params) do
      {:ok, _artist} ->
        {:noreply,
         socket
         |> put_flash(:info, "Artist created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

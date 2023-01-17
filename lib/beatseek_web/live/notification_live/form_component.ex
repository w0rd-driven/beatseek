defmodule BeatseekWeb.NotificationLive.FormComponent do
  use BeatseekWeb, :live_component

  alias Beatseek.Notifications

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage notification records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="notification-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :icon}} type="text" label="Icon" />
        <.input field={{f, :subject}} type="text" label="Subject" />
        <.input field={{f, :body}} type="text" label="Body" />
        <.input field={{f, :url}} type="text" label="Url" />
        <.input field={{f, :type}} type="text" label="Type" />
        <.input field={{f, :seen_at}} type="text" label="Seen at" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Notification</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{notification: notification} = assigns, socket) do
    changeset = Notifications.change_notification(notification)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"notification" => notification_params}, socket) do
    changeset =
      socket.assigns.notification
      |> Notifications.change_notification(notification_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"notification" => notification_params}, socket) do
    save_notification(socket, socket.assigns.action, notification_params)
  end

  defp save_notification(socket, :edit, notification_params) do
    case Notifications.update_notification(socket.assigns.notification, notification_params) do
      {:ok, _notification} ->
        {:noreply,
         socket
         |> put_flash(:info, "Notification updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_notification(socket, :new, notification_params) do
    case Notifications.create_notification(notification_params) do
      {:ok, _notification} ->
        {:noreply,
         socket
         |> put_flash(:info, "Notification created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

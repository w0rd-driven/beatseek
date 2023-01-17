defmodule Beatseek.Notifications.Notification do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notifications" do
    field :body, :string
    field :icon, :string
    field :seen_at, :utc_datetime_usec
    field :subject, :string
    field :type, Ecto.Enum, values: [:not_owned, :new_release, :upcoming_release]
    field :url, :string
    field :album_id, :id

    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:icon, :subject, :body, :url, :type, :seen_at])
    |> validate_required([:subject, :type])
  end
end

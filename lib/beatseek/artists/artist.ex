defmodule Beatseek.Artists.Artist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "artists" do
    field :checked_at, :utc_datetime_usec
    field :image_url, :string
    field :name, :string
    field :path, :string
    has_many :albums, Beatseek.Albums.Album

    timestamps()
  end

  @doc false
  def changeset(artist, attrs) do
    artist
    |> cast(attrs, [:name, :path, :image_url, :checked_at])
    |> validate_required([:name])
  end
end

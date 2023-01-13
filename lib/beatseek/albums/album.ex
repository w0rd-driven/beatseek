defmodule Beatseek.Albums.Album do
  use Ecto.Schema
  import Ecto.Changeset

  schema "albums" do
    field :genre, :string
    field :image_url, :string
    field :is_owned, :boolean, default: false
    field :name, :string
    field :path, :string
    field :release_date, :date
    field :year, :string
    field :artist_id, :id

    timestamps()
  end

  @doc false
  def changeset(album, attrs) do
    album
    |> cast(attrs, [:name, :genre, :year, :release_date, :is_owned, :path, :image_url])
    |> validate_required([:name, :genre, :year, :release_date, :is_owned, :path, :image_url])
  end
end

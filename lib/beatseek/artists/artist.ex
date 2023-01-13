defmodule Beatseek.Artists.Artist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "artists" do
    field :image_url, :string
    field :name, :string
    field :path, :string

    timestamps()
  end

  @doc false
  def changeset(artist, attrs) do
    artist
    |> cast(attrs, [:name, :path, :image_url])
    |> validate_required([:name, :path, :image_url])
  end
end

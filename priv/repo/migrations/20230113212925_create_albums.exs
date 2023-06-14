defmodule Beatseek.Repo.Migrations.CreateAlbums do
  use Ecto.Migration

  def change do
    create table(:albums) do
      add :name, :string
      add :genre, :string
      add :year, :string
      add :release_date, :date
      add :is_owned, :boolean, default: false, null: false
      add :path, :string
      add :image_url, :string
      add :artist_id, references(:artists, on_delete: :nothing)

      timestamps()
    end

    create index(:albums, [:artist_id])
    create unique_index(:albums, [:name, :artist_id])
  end
end

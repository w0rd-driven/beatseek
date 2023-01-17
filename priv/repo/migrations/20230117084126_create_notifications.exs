defmodule Beatseek.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :icon, :string
      add :subject, :string
      add :body, :text
      add :url, :text
      add :type, :string
      add :seen_at, :utc_datetime_usec
      add :album_id, references(:albums, on_delete: :nothing)

      timestamps()
    end

    create index(:notifications, [:album_id])
  end
end

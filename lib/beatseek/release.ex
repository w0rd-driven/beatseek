defmodule Beatseek.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :beatseek

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def ecto_drop do
    load_app()

    for repo <- repos() do
      drop_database(repo)
    end
  end

  defp drop_database(repo) do
    case repo.__adapter__.storage_down(repo.config) do
      :ok ->
        IO.puts("The database for #{inspect(repo)} has been dropped")

      {:error, :already_down} ->
        IO.puts("The database for #{inspect(repo)} has already been dropped")

      {:error, term} when is_binary(term) ->
        raise "The database for #{inspect(repo)} couldn't be dropped: #{term}"

      {:error, term} ->
        raise "The database for #{inspect(repo)} couldn't be dropped: #{inspect(term)}"
    end
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end

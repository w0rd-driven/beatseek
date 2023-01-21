defmodule Beatseek.Workers.VerificationWorker do
  use Oban.Worker

  import Ecto.Query

  alias Beatseek.{Repo, Artists}
  alias Beatseek.Artists.Artist
  alias Beatseek.Verification.Spotify

  @backfill_delay 1

  @impl true
  def perform(%{args: %{"id" => id, "backfill" => true}}) do
    with :ok <- perform(%{args: %{"id" => id}}) do
      case fetch_next(id) do
        next_id when is_integer(next_id) ->
          %{id: next_id, backfill: true}
          |> new(schedule_in: @backfill_delay)
          |> Oban.insert()

        nil ->
          :ok
      end
    end
  end

  def perform(%{args: %{"id" => id}}) do
    update_albums(id)
  end

  defp fetch_next(current_id) do
    Artist
    |> where([artist], is_nil(artist.verified_at))
    |> where([artist], artist.id > ^current_id)
    |> order_by(asc: :id)
    |> limit(1)
    |> select([artist], artist.id)
    |> Repo.one()
  end

  defp update_albums(id) do
    case Spotify.verify(id) |> Enum.at(0) do
      :ok ->
        artist = Artists.get_artist!(id)
        is_nil(artist) || Artists.update_artist(artist, %{verified_at: DateTime.utc_now()})

      [] ->
        :ok

      nil ->
        :ok
    end

    :ok
  end
end

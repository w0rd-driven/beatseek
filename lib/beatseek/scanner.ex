defmodule Beatseek.Scanner do
  alias Beatseek.Artists
  alias Beatseek.Albums
  alias Beatseek.Transformers.ArtistTransformer
  alias Beatseek.Transformers.AlbumTransformer

  def full_scan(directory \\ "/Users/jbrayton/Music/iTunes/iTunes Media/Music") do
    files = "/**/*.mp3"

    path = Path.join(directory, files)

    Path.wildcard(path)
    |> Enum.uniq_by(fn file_path ->
      # Now we filter by parent directory, from 4823 to 443
      file_path
      |> Path.dirname()

      # |> IO.inspect(label: "Basename")
    end)
    |> Enum.map(fn path ->
      # Read tags
      case Beatseek.MP3Stat.parse(path, no_duration: true) do
        {:ok, tag} -> tag
        {:error, _error} -> %{}
      end
    end)
    |> Enum.uniq_by(fn tag ->
      # Filter down to unique artist/album pairs
      # It would be quicker to use a MapSet to stay unique
      # ETS could work but overkill, why not benchmark it?
      if tag != %{} do
        tag.artist && tag.album
      end
    end)
    |> Enum.sort_by(
      fn tag ->
        tag.artist
      end,
      :asc
    )
  end

  def scan(directory \\ "/Users/jbrayton/Music/iTunes/iTunes Media/Music") do
    files = "/**/*.mp3"
    path = Path.join(directory, files)

    Path.wildcard(path)
    |> Enum.uniq_by(&Path.dirname/1)
    |> Enum.map(fn path ->
      case Beatseek.MP3Stat.parse(path, no_duration: true) do
        {:ok, tag} -> tag
        {:error, _error} -> %{}
      end
    end)
    |> Enum.uniq_by(&(&1 != %{} && (&1.artist && &1.album)))
    |> Enum.filter(&(!is_nil(&1.artist)))
    |> Enum.map(&create_records/1)
  end

  def create_records(id3) do
    artist_params = ArtistTransformer.transform(id3)
    album_params = AlbumTransformer.transform(id3)

    with {:ok, artist} <- Artists.upsert_artist(artist_params),
         {:ok, album} <- Albums.upsert_album(album_params, artist) do
      %{id3: id3, artist: artist, album: album}
    end
  end
end

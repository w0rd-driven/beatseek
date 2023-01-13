defmodule Beatseek.Transformers.ArtistTransformer do
  def transform(id3) do
    %{
      name: id3.artist,
      path: get_path(id3.path, id3.artist)
    }
  end

  defp get_path(path, artist) do
    album_directory = path |> Path.dirname()
    artist_directory = album_directory |> Path.dirname()
    directory_name = artist_directory |> Path.basename()

    if String.jaro_distance(artist, directory_name) >= 0.8 do
      artist_directory
    else
      album_directory
    end
  end
end

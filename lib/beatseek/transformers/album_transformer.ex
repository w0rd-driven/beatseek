defmodule Beatseek.Transformers.AlbumTransformer do
  def transform(id3, is_owned \\ true) do
    %{
      name: id3.album,
      genre: id3.genre,
      year: id3.year,
      is_owned: is_owned,
      path: get_path(id3.path)
    }
  end

  defp get_path(path) do
    path |> Path.dirname()
  end
end

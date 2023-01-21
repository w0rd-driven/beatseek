defmodule Beatseek.Transformers.SpotifyAlbumTransformer do
  def transform(album) do
    %{
      name: album.name,
      release_date: album.release_date,
      image_url: get_image(album.images)
    }
  end

  def get_image(images) do
    images
    |> Enum.filter(fn image ->
      image |> Map.get("height") == 300
    end)
    |> Enum.map(fn image ->
      image["url"]
    end)
    |> Enum.at(0)
  end
end

defmodule Beatseek.Transformers.SpotifyArtistTransformer do
  def transform(artist) do
    %{
      image_url: get_image(artist.images)
    }
  end

  defp get_image(images) do
    images
    |> Enum.filter(fn image ->
      image |> Map.get("height") == 320
    end)
    |> Enum.map(fn image ->
      image["url"]
    end)
    |> Enum.at(0)
  end
end

defmodule Beatseek.Transformers.SpotifyAlbumTransformer do
  def transform(album) do
    %{
      name: album.name,
      release_date: album.release_date,
      year: get_year(album.release_date),
      image_url: get_image(album.images)
    }
  end

  defp get_year(year) when is_binary(year) do
    regex = ~r/(?<year>\d+)-(?<month>\d+)-(?<day>\d+)/
    captures = Regex.named_captures(regex, year)
    do_get_year(captures) || year
  end

  defp get_year(nil), do: nil

  defp do_get_year(%{"day" => _, "month" => _, "year" => year}), do: year
  defp do_get_year(nil), do: nil

  defp get_image(images) do
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

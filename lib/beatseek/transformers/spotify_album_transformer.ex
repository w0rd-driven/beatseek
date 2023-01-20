defmodule Beatseek.Transformers.SpotifyAlbumTransformer do
  def transform(album) do
    %{
      name: album.name,
      release_date: album.release_date
    }
  end
end

defmodule Beatseek.ArtistsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Beatseek.Artists` context.
  """

  @doc """
  Generate a artist.
  """
  def artist_fixture(attrs \\ %{}) do
    {:ok, artist} =
      attrs
      |> Enum.into(%{
        image_url: "some image_url",
        name: "some name",
        path: "some path"
      })
      |> Beatseek.Artists.create_artist()

    artist
  end
end

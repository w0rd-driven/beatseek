defmodule Beatseek.AlbumsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Beatseek.Albums` context.
  """

  @doc """
  Generate a album.
  """
  def album_fixture(attrs \\ %{}) do
    {:ok, album} =
      attrs
      |> Enum.into(%{
        genre: "some genre",
        image_url: "some image_url",
        is_owned: true,
        name: "some name",
        path: "some path",
        release_date: ~D[2023-01-12],
        year: "some year"
      })
      |> Beatseek.Albums.create_album()

    album
  end
end

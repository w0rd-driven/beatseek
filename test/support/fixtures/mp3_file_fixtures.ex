defmodule Beatseek.MP3FileFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Beatseek.MP3Stat` context.
  """

  @doc """
  Generate a MP3Stat with artist information.
  """
  def artist_fixture(attrs \\ %{}) do
    struct!(
      %Beatseek.MP3Stat{},
      Enum.into(attrs, %{
        artist: "Periphery",
        path: "/Users/jbrayton/Music/iTunes/iTunes Media/Music/Periphery/Periphery/1-01 Insomnia.mp3"
      })
    )
  end

  @doc """
  Generate a MP3Stat with artist and album information.
  """
  def album_fixture(attrs \\ %{}) do
    struct!(
      %Beatseek.MP3Stat{},
      Enum.into(attrs, %{
        artist: "Periphery",
        album: "Periphery",
        genre: "Progressive Metal / Math Metal / Djent",
        year: "2010",
        path: "/Users/jbrayton/Music/iTunes/iTunes Media/Music/Periphery/Periphery/1-01 Insomnia.mp3"
      })
    )
  end
end

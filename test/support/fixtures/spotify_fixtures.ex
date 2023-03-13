defmodule Beatseek.SpotifyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  Spotify entities via the `SpotifyEx` contexts.
  """

  @doc """
  Generate a auth credential.
  """
  def spotify_credential_fixture(attrs \\ %{}) do
    struct!(
      Spotify.Credentials,
      Enum.into(attrs, %{
        access_token:
          "BQCTYloFMEnBNHs8VQardg4FhBj1i9N977djwdiR3SDmzNeeZG-RGuD92mjfJAu9UMJz9UzNxQEnGQNyT7IENOAbvWtCSfRGMoFtk9CgUhkfpUle-kTL",
        refresh_token: nil
      })
    )
  end

  @doc """
  Generate an artist.
  """
  def spotify_artist_fixture(attrs \\ %{}) do
    struct!(
      Spotify.Artist,
      Enum.into(attrs, %{
        id: "6d24kC5fxHFOSEAmjQPPhc",
        name: "Periphery",
        genres: ["djent", "melodic metalcore", "progressive metal", "progressive metalcore"],
        images: [
          %{
            "height" => 640,
            "url" => "https://i.scdn.co/image/ab6761610000e5ebae2304891734b9d9fafe1c8d",
            "width" => 640
          },
          %{
            "height" => 320,
            "url" => "https://i.scdn.co/image/ab67616100005174ae2304891734b9d9fafe1c8d",
            "width" => 320
          },
          %{
            "height" => 160,
            "url" => "https://i.scdn.co/image/ab6761610000f178ae2304891734b9d9fafe1c8d",
            "width" => 160
          }
        ],
        type: "artist",
        uri: "spotify:artist:6d24kC5fxHFOSEAmjQPPhc"
      })
    )
  end

  @doc """
  Generate an album.
  """
  def spotify_album_fixture(attrs \\ %{}) do
    struct!(
      Spotify.Album,
      Enum.into(attrs, %{
        id: "5g2wuopyi9BfhFwztSWFKU",
        name: "Periphery",
        images: [
          %{
            "height" => 640,
            "url" => "https://i.scdn.co/image/ab67616d0000b27376c5a9aa980d3a43eaa19583",
            "width" => 640
          },
          %{
            "height" => 300,
            "url" => "https://i.scdn.co/image/ab67616d00001e0276c5a9aa980d3a43eaa19583",
            "width" => 300
          },
          %{
            "height" => 64,
            "url" => "https://i.scdn.co/image/ab67616d0000485176c5a9aa980d3a43eaa19583",
            "width" => 64
          }
        ],
        release_date: "2010-04-20",
        release_date_precision: "day"
      })
    )
  end
end

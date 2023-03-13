defmodule Beatseek.ScannerTest do
  use Beatseek.DataCase, async: true

  alias Beatseek.Scanner
  alias Beatseek.Artists.Artist
  alias Beatseek.Albums.Album

  @scan_directory System.get_env("SCAN_DIRECTORY")
  @fixture_directory "test/support/fixtures/music/Periphery"

  defp setup_expected() do
    artist =
      struct!(
        Artist,
        Enum.into(%{}, %{
          name: "Periphery",
          path: @fixture_directory
        })
      )

    album =
      struct!(
        Album,
        Enum.into(%{}, %{
          name: "Periphery",
          path: Path.join(@fixture_directory, "Periphery"),
          genre: "Progressive Metal / Math Metal / Djent",
          year: "2010"
        })
      )

    album_ii =
      struct!(
        Album,
        Enum.into(%{}, %{
          name: "Periphery II",
          path: Path.join(@fixture_directory, "Periphery II"),
          genre: "Progressive Metal / Math Metal / Djent",
          year: "2012"
        })
      )

    album_iii =
      struct!(
        Album,
        Enum.into(%{}, %{
          name: "Periphery III: Select Difficulty",
          path: Path.join(@fixture_directory, "Periphery III"),
          genre: nil,
          year: "2016"
        })
      )

    [
      %{album: album, id3: nil, artist: artist},
      %{album: album_ii, id3: nil, artist: artist},
      %{album: album_iii, id3: nil, artist: artist}
    ]
  end

  defp assert_expected_albums(expected, values) do
    expected
    |> Enum.each(fn expected ->
      found = values |> Enum.find(fn value -> expected[:album].name == value[:album].name end)

      # This seems a little brittle as we always expect the Enum.find to not return nil.
      # We are inspecting structs we've injected values into vs what is serialized to the database, which has some value.
      assert expected[:artist].name == found[:artist].name
      assert expected[:album].name == found[:album].name
      assert expected[:album].genre == found[:album].genre
      assert expected[:album].year == found[:album].year
    end)
  end

  describe "scan/0" do
    # @describetag :integration
    test "uses the config directory to create artists and albums" do
      Application.put_env(:beatseek, :scan_directory, @fixture_directory)

      setup_expected()
      |> assert_expected_albums(Scanner.scan())
    after
      Application.put_env(:beatseek, :scan_directory, @scan_directory)
    end
  end

  describe "scan/1" do
    @tag :tmp_dir

    test "an empty directory returns an empty list", %{tmp_dir: tmp_dir} do
      assert File.dir?(tmp_dir)
      assert Scanner.scan(tmp_dir) == []
    after
      # No clue why ExUnit isn't cleaning this during tear down
      File.rm_rf!("tmp/")
    end

    test "a valid directory creates artists and albums" do
      setup_expected()
      |> assert_expected_albums(Scanner.scan(@fixture_directory))
    end

    test "a nil directory uses the config directory to create artists and albums" do
      Application.put_env(:beatseek, :scan_directory, @fixture_directory)

      setup_expected()
      |> assert_expected_albums(Scanner.scan())
    after
      Application.put_env(:beatseek, :scan_directory, @scan_directory)
    end
  end
end

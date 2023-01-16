defmodule Beatseek.ArtistsTest do
  use Beatseek.DataCase

  alias Beatseek.Artists

  describe "artists" do
    alias Beatseek.Artists.Artist

    import Beatseek.ArtistsFixtures

    @invalid_attrs %{checked_at: nil, image_url: nil, name: nil, path: nil}

    test "list_artists/0 returns all artists" do
      artist = artist_fixture()
      assert Artists.list_artists() == [artist]
    end

    test "get_artist!/1 returns the artist with given id" do
      artist = artist_fixture()
      assert Artists.get_artist!(artist.id) == artist
    end

    test "create_artist/1 with valid data creates a artist" do
      valid_attrs = %{
        checked_at: ~U[2023-01-15 21:16:00.000000Z],
        image_url: "some image_url",
        name: "some name",
        path: "some path"
      }

      assert {:ok, %Artist{} = artist} = Artists.create_artist(valid_attrs)
      assert artist.checked_at == ~U[2023-01-15 21:16:00.000000Z]
      assert artist.image_url == "some image_url"
      assert artist.name == "some name"
      assert artist.path == "some path"
    end

    test "create_artist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Artists.create_artist(@invalid_attrs)
    end

    test "update_artist/2 with valid data updates the artist" do
      artist = artist_fixture()

      update_attrs = %{
        checked_at: ~U[2023-01-16 21:16:00.000000Z],
        image_url: "some updated image_url",
        name: "some updated name",
        path: "some updated path"
      }

      assert {:ok, %Artist{} = artist} = Artists.update_artist(artist, update_attrs)
      assert artist.checked_at == ~U[2023-01-16 21:16:00.000000Z]
      assert artist.image_url == "some updated image_url"
      assert artist.name == "some updated name"
      assert artist.path == "some updated path"
    end

    test "update_artist/2 with invalid data returns error changeset" do
      artist = artist_fixture()
      assert {:error, %Ecto.Changeset{}} = Artists.update_artist(artist, @invalid_attrs)
      assert artist == Artists.get_artist!(artist.id)
    end

    test "delete_artist/1 deletes the artist" do
      artist = artist_fixture()
      assert {:ok, %Artist{}} = Artists.delete_artist(artist)
      assert_raise Ecto.NoResultsError, fn -> Artists.get_artist!(artist.id) end
    end

    test "change_artist/1 returns a artist changeset" do
      artist = artist_fixture()
      assert %Ecto.Changeset{} = Artists.change_artist(artist)
    end
  end
end

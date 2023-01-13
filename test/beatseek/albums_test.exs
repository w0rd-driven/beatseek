defmodule Beatseek.AlbumsTest do
  use Beatseek.DataCase

  alias Beatseek.Albums

  describe "albums" do
    alias Beatseek.Albums.Album

    import Beatseek.AlbumsFixtures

    @invalid_attrs %{genre: nil, image_url: nil, is_owned: nil, name: nil, path: nil, release_date: nil, year: nil}

    test "list_albums/0 returns all albums" do
      album = album_fixture()
      assert Albums.list_albums() == [album]
    end

    test "get_album!/1 returns the album with given id" do
      album = album_fixture()
      assert Albums.get_album!(album.id) == album
    end

    test "create_album/1 with valid data creates a album" do
      valid_attrs = %{genre: "some genre", image_url: "some image_url", is_owned: true, name: "some name", path: "some path", release_date: ~D[2023-01-12], year: "some year"}

      assert {:ok, %Album{} = album} = Albums.create_album(valid_attrs)
      assert album.genre == "some genre"
      assert album.image_url == "some image_url"
      assert album.is_owned == true
      assert album.name == "some name"
      assert album.path == "some path"
      assert album.release_date == ~D[2023-01-12]
      assert album.year == "some year"
    end

    test "create_album/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Albums.create_album(@invalid_attrs)
    end

    test "update_album/2 with valid data updates the album" do
      album = album_fixture()
      update_attrs = %{genre: "some updated genre", image_url: "some updated image_url", is_owned: false, name: "some updated name", path: "some updated path", release_date: ~D[2023-01-13], year: "some updated year"}

      assert {:ok, %Album{} = album} = Albums.update_album(album, update_attrs)
      assert album.genre == "some updated genre"
      assert album.image_url == "some updated image_url"
      assert album.is_owned == false
      assert album.name == "some updated name"
      assert album.path == "some updated path"
      assert album.release_date == ~D[2023-01-13]
      assert album.year == "some updated year"
    end

    test "update_album/2 with invalid data returns error changeset" do
      album = album_fixture()
      assert {:error, %Ecto.Changeset{}} = Albums.update_album(album, @invalid_attrs)
      assert album == Albums.get_album!(album.id)
    end

    test "delete_album/1 deletes the album" do
      album = album_fixture()
      assert {:ok, %Album{}} = Albums.delete_album(album)
      assert_raise Ecto.NoResultsError, fn -> Albums.get_album!(album.id) end
    end

    test "change_album/1 returns a album changeset" do
      album = album_fixture()
      assert %Ecto.Changeset{} = Albums.change_album(album)
    end
  end
end

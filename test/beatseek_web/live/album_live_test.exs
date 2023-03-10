defmodule BeatseekWeb.AlbumLiveTest do
  use BeatseekWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Beatseek.ArtistsFixtures
  import Beatseek.AlbumsFixtures

  defp create_album(_) do
    artist = artist_fixture()
    album = album_fixture(artist_id: artist.id)
    %{album: album}
  end

  describe "Index" do
    setup [:create_album]

    test "lists all albums", %{conn: conn, album: album} do
      {:ok, _index_live, html} = live(conn, ~p"/albums")

      assert html =~ "Albums"
      assert html =~ album.name
    end
  end

  describe "Show" do
    setup [:create_album]

    test "displays album", %{conn: conn, album: album} do
      {:ok, _show_live, html} = live(conn, ~p"/albums/#{album}")

      assert html =~ "Show Album"
      assert html =~ album.name
    end
  end
end

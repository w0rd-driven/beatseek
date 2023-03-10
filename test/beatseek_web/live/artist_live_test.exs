defmodule BeatseekWeb.ArtistLiveTest do
  use BeatseekWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Beatseek.ArtistsFixtures

  defp create_artist(_) do
    artist = artist_fixture()
    %{artist: artist}
  end

  describe "Index" do
    setup [:create_artist]

    test "lists all artists", %{conn: conn, artist: artist} do
      {:ok, _index_live, html} = live(conn, ~p"/artists")

      assert html =~ "Artists"
      assert html =~ artist.name
    end
  end

  describe "Show" do
    setup [:create_artist]

    test "displays artist", %{conn: conn, artist: artist} do
      {:ok, _show_live, html} = live(conn, ~p"/artists/#{artist}")

      assert html =~ "Show Artist"
      assert html =~ artist.name
    end
  end
end

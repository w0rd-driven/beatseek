defmodule BeatseekWeb.ArtistLiveTest do
  use BeatseekWeb.ConnCase

  import Phoenix.LiveViewTest
  import Beatseek.ArtistsFixtures

  @create_attrs %{image_url: "some image_url", name: "some name"}
  @update_attrs %{image_url: "some updated image_url", name: "some updated name"}
  @invalid_attrs %{image_url: nil, name: nil}

  defp create_artist(_) do
    artist = artist_fixture()
    %{artist: artist}
  end

  describe "Index" do
    setup [:create_artist]

    test "lists all artists", %{conn: conn, artist: artist} do
      {:ok, _index_live, html} = live(conn, ~p"/artists")

      assert html =~ "Listing Artists"
      assert html =~ artist.image_url
    end

    test "saves new artist", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/artists")

      assert index_live |> element("a", "New Artist") |> render_click() =~
               "New Artist"

      assert_patch(index_live, ~p"/artists/new")

      assert index_live
             |> form("#artist-form", artist: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#artist-form", artist: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/artists")

      assert html =~ "Artist created successfully"
      assert html =~ "some image_url"
    end

    test "updates artist in listing", %{conn: conn, artist: artist} do
      {:ok, index_live, _html} = live(conn, ~p"/artists")

      assert index_live |> element("#artists-#{artist.id} a", "Edit") |> render_click() =~
               "Edit Artist"

      assert_patch(index_live, ~p"/artists/#{artist}/edit")

      assert index_live
             |> form("#artist-form", artist: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#artist-form", artist: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/artists")

      assert html =~ "Artist updated successfully"
      assert html =~ "some updated image_url"
    end

    test "deletes artist in listing", %{conn: conn, artist: artist} do
      {:ok, index_live, _html} = live(conn, ~p"/artists")

      assert index_live |> element("#artists-#{artist.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#artist-#{artist.id}")
    end
  end

  describe "Show" do
    setup [:create_artist]

    test "displays artist", %{conn: conn, artist: artist} do
      {:ok, _show_live, html} = live(conn, ~p"/artists/#{artist}")

      assert html =~ "Show Artist"
      assert html =~ artist.image_url
    end

    test "updates artist within modal", %{conn: conn, artist: artist} do
      {:ok, show_live, _html} = live(conn, ~p"/artists/#{artist}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Artist"

      assert_patch(show_live, ~p"/artists/#{artist}/show/edit")

      assert show_live
             |> form("#artist-form", artist: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#artist-form", artist: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/artists/#{artist}")

      assert html =~ "Artist updated successfully"
      assert html =~ "some updated image_url"
    end
  end
end

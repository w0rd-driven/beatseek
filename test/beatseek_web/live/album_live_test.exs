defmodule BeatseekWeb.AlbumLiveTest do
  use BeatseekWeb.ConnCase

  import Phoenix.LiveViewTest
  import Beatseek.AlbumsFixtures

  @create_attrs %{genre: "some genre", image_url: "some image_url", is_owned: true, name: "some name", path: "some path", release_date: "2023-1-12", year: "some year"}
  @update_attrs %{genre: "some updated genre", image_url: "some updated image_url", is_owned: false, name: "some updated name", path: "some updated path", release_date: "2023-1-13", year: "some updated year"}
  @invalid_attrs %{genre: nil, image_url: nil, is_owned: false, name: nil, path: nil, release_date: nil, year: nil}

  defp create_album(_) do
    album = album_fixture()
    %{album: album}
  end

  describe "Index" do
    setup [:create_album]

    test "lists all albums", %{conn: conn, album: album} do
      {:ok, _index_live, html} = live(conn, ~p"/albums")

      assert html =~ "Listing Albums"
      assert html =~ album.genre
    end

    test "saves new album", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/albums")

      assert index_live |> element("a", "New Album") |> render_click() =~
               "New Album"

      assert_patch(index_live, ~p"/albums/new")

      assert index_live
             |> form("#album-form", album: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#album-form", album: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/albums")

      assert html =~ "Album created successfully"
      assert html =~ "some genre"
    end

    test "updates album in listing", %{conn: conn, album: album} do
      {:ok, index_live, _html} = live(conn, ~p"/albums")

      assert index_live |> element("#albums-#{album.id} a", "Edit") |> render_click() =~
               "Edit Album"

      assert_patch(index_live, ~p"/albums/#{album}/edit")

      assert index_live
             |> form("#album-form", album: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#album-form", album: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/albums")

      assert html =~ "Album updated successfully"
      assert html =~ "some updated genre"
    end

    test "deletes album in listing", %{conn: conn, album: album} do
      {:ok, index_live, _html} = live(conn, ~p"/albums")

      assert index_live |> element("#albums-#{album.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#album-#{album.id}")
    end
  end

  describe "Show" do
    setup [:create_album]

    test "displays album", %{conn: conn, album: album} do
      {:ok, _show_live, html} = live(conn, ~p"/albums/#{album}")

      assert html =~ "Show Album"
      assert html =~ album.genre
    end

    test "updates album within modal", %{conn: conn, album: album} do
      {:ok, show_live, _html} = live(conn, ~p"/albums/#{album}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Album"

      assert_patch(show_live, ~p"/albums/#{album}/show/edit")

      assert show_live
             |> form("#album-form", album: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#album-form", album: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/albums/#{album}")

      assert html =~ "Album updated successfully"
      assert html =~ "some updated genre"
    end
  end
end

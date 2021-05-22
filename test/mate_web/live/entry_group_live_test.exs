defmodule MateWeb.EntryGroupLiveTest do
  use MateWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Mate.Transactions

  @create_attrs %{amount: "120.5", end_date: ~D[2010-04-17], periodicity: 42, periodicity_buffer: 42, periodicity_type: "some periodicity_type", recurrent: true, start_date: ~D[2010-04-17], status: "some status"}
  @update_attrs %{amount: "456.7", end_date: ~D[2011-05-18], periodicity: 43, periodicity_buffer: 43, periodicity_type: "some updated periodicity_type", recurrent: false, start_date: ~D[2011-05-18], status: "some updated status"}
  @invalid_attrs %{amount: nil, end_date: nil, periodicity: nil, periodicity_buffer: nil, periodicity_type: nil, recurrent: nil, start_date: nil, status: nil}

  defp fixture(:entry_group) do
    {:ok, entry_group} = Transactions.create_entry_group(@create_attrs)
    entry_group
  end

  defp create_entry_group(_) do
    entry_group = fixture(:entry_group)
    %{entry_group: entry_group}
  end

  describe "Index" do
    setup [:create_entry_group]

    test "lists all entry_groups", %{conn: conn, entry_group: entry_group} do
      {:ok, _index_live, html} = live(conn, Routes.entry_group_index_path(conn, :index))

      assert html =~ "Listing Entry groups"
      assert html =~ entry_group.periodicity_type
    end

    test "saves new entry_group", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.entry_group_index_path(conn, :index))

      assert index_live |> element("a", "New Entry group") |> render_click() =~
               "New Entry group"

      assert_patch(index_live, Routes.entry_group_index_path(conn, :new))

      assert index_live
             |> form("#entry_group-form", entry_group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#entry_group-form", entry_group: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.entry_group_index_path(conn, :index))

      assert html =~ "Entry group created successfully"
      assert html =~ "some periodicity_type"
    end

    test "updates entry_group in listing", %{conn: conn, entry_group: entry_group} do
      {:ok, index_live, _html} = live(conn, Routes.entry_group_index_path(conn, :index))

      assert index_live |> element("#entry_group-#{entry_group.id} a", "Edit") |> render_click() =~
               "Edit Entry group"

      assert_patch(index_live, Routes.entry_group_index_path(conn, :edit, entry_group))

      assert index_live
             |> form("#entry_group-form", entry_group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#entry_group-form", entry_group: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.entry_group_index_path(conn, :index))

      assert html =~ "Entry group updated successfully"
      assert html =~ "some updated periodicity_type"
    end

    test "deletes entry_group in listing", %{conn: conn, entry_group: entry_group} do
      {:ok, index_live, _html} = live(conn, Routes.entry_group_index_path(conn, :index))

      assert index_live |> element("#entry_group-#{entry_group.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#entry_group-#{entry_group.id}")
    end
  end

  describe "Show" do
    setup [:create_entry_group]

    test "displays entry_group", %{conn: conn, entry_group: entry_group} do
      {:ok, _show_live, html} = live(conn, Routes.entry_group_show_path(conn, :show, entry_group))

      assert html =~ "Show Entry group"
      assert html =~ entry_group.periodicity_type
    end

    test "updates entry_group within modal", %{conn: conn, entry_group: entry_group} do
      {:ok, show_live, _html} = live(conn, Routes.entry_group_show_path(conn, :show, entry_group))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Entry group"

      assert_patch(show_live, Routes.entry_group_show_path(conn, :edit, entry_group))

      assert show_live
             |> form("#entry_group-form", entry_group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#entry_group-form", entry_group: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.entry_group_show_path(conn, :show, entry_group))

      assert html =~ "Entry group updated successfully"
      assert html =~ "some updated periodicity_type"
    end
  end
end

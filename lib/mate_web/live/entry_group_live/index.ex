defmodule MateWeb.EntryGroupLive.Index do
  @moduledoc false
  use MateWeb, :live_view

  alias Mate.Transactions
  alias Mate.Transactions.EntryGroup

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :entry_groups, list_entry_groups())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Entry group")
    |> assign(:entry_group, Transactions.get_entry_group!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Entry group")
    |> assign(:entry_group, %EntryGroup{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Entry groups")
    |> assign(:entry_group, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    entry_group = Transactions.get_entry_group!(id)
    {:ok, _} = Transactions.delete_entry_group(entry_group)

    {:noreply, assign(socket, :entry_groups, list_entry_groups())}
  end

  defp list_entry_groups do
    Transactions.list_entry_groups()
  end
end

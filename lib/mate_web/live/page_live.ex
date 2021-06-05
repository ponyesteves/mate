defmodule MateWeb.PageLive do
  @moduledoc false
  use MateWeb, :live_view
  alias Mate.Conty

  alias Mate.Transactions.EntryGroup
  alias Mate.Conty.Entry

  @impl true
  def mount(_params, _session, socket) do

    {:ok, balances} = Conty.balances_filtered_by_account_type(:assets, %{end_date: Date.utc_today()})

    {:ok, assign(socket, balances: balances)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params), do: socket

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Nueva entrada")
    |> assign(:entry_group, %EntryGroup{start_date: Date.utc_today()})
  end

  defp apply_action(socket, :adjust_balance, %{"id" => account_id}) do
    socket
    |> assign(:page_title, "Ajustar Balance")
    |> assign(:account_id, account_id)
  end
end

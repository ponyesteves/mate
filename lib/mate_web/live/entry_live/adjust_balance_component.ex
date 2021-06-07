defmodule MateWeb.EntryLive.AdjustBalanceComponent do
  @moduledoc false
  use MateWeb, :live_component

  alias Mate.Conty

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

  @impl true
  def handle_event("save", %{"adjust_balance" => %{"amount" => amount}}, socket) do
    adjust_account_id = socket.assigns.id |> String.to_integer()

    balance = Enum.find(socket.assigns.balances, fn balance -> balance.account.id == adjust_account_id end)

    balance_diff = Decimal.sub(amount, balance.amount)

    entry_attrs = %{
      date: Date.utc_today(),
      type: "adjust",
      account_credit_id: adjust_account_id,
      account_debit_id: 2,
      entry_items: [
        %{account_id: adjust_account_id, amount: balance_diff},
        %{account_id: 2, amount: Decimal.negate(balance_diff)}
      ]
    }

    Conty.change_entry(%Conty.Entry{}, entry_attrs)
    |> Mate.Repo.insert()

    {:noreply,
     socket
     |> put_flash(:info, "Balance ajustado")
     |> push_redirect(to: socket.assigns.return_to)}
  end
end

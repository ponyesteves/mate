defmodule MateWeb.EntryLive.MoveBalanceComponent do
  @moduledoc false
  use MateWeb, :live_component

  alias Mate.Conty

  @impl true
  def handle_event("save", %{"adjust_balance" => %{"amount" => amount, "target_account_id" => target_account_id}}, socket) do
    adjust_account_id = socket.assigns.id |> String.to_integer()

    entry_attrs = %{
      date: Date.utc_today(),
      type: "adjust",
      account_credit_id: target_account_id,
      account_debit_id: adjust_account_id,
      entry_items: [
        %{account_id: target_account_id, amount: amount},
        %{account_id: adjust_account_id, amount: Decimal.negate(amount)}
      ]
    }

    Conty.change_entry(%Conty.Entry{}, entry_attrs)
    |> Mate.Repo.insert()

    {:noreply,
     socket
     |> push_patch(to: socket.assigns.return_to)}
  end
end

defmodule MateWeb.EntryLive.AdjustBalanceComponent do
  @moduledoc false
  use MateWeb, :live_component

  alias Mate.Conty

  @impl true
  def handle_event(
        "save",
        %{"adjust_balance" => %{"amount" => amount}},
        %{
          assigns: %{
            account_debit_id: account_debit_id,
            account_credit_id: account_credit_id,
            current_balances: current_balances
          }
        } = socket
      ) do
    account_debit_id = String.to_integer(account_debit_id)
    account_credit_id = String.to_integer(account_credit_id)

    amount = (socket.assigns.card == :expenses && Decimal.negate(amount)) || amount

    balance =
      Enum.find(current_balances, fn
        %{account: account, source: %Ecto.Association.NotLoaded{}} ->
          account.id == account_debit_id

        %{account: account, source: source} ->
          account.id == account_debit_id &&
            source.id == account_credit_id
      end)

    balance_diff = Decimal.sub(amount, balance.amount)

    entry_attrs = %{
      date: Date.utc_today(),
      type: "adjust",
      account_debit_id: account_debit_id,
      account_credit_id: account_credit_id,
      entry_items: [
        %{
          account_id: account_debit_id,
          source_id: account_credit_id,
          amount: balance_diff
        },
        %{
          account_id: account_credit_id,
          source_id: account_debit_id,
          amount: Decimal.negate(balance_diff)
        }
      ]
    }

    Conty.change_entry(%Conty.Entry{}, entry_attrs)
    |> Mate.Repo.insert()

    {:noreply,
     socket
     |> push_patch(to: socket.assigns.return_to)}
  end
end

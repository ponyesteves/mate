defmodule MateWeb.PageLive do
  @moduledoc false
  use MateWeb, :live_view
  alias Mate.Conty

  alias Mate.Transactions.EntryGroup

  alias Mate.Taggable

  @topic "test_pub_sub"

  @impl true
  def mount(_params, _session, socket) do
    MateWeb.Endpoint.subscribe(@topic)

    {:ok,
     assign(socket,
       balances: [],
       savings: [],
       expenses: [],
       amount: 0
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info(
        %{
          topic: @topic,
          event: "refresh",
          payload: %{balances: balances, savings: savings, expenses: expenses}
        },
        socket
      ) do
    {:noreply, assign(socket, balances: balances, savings: savings, expenses: expenses)}
  end

  defp apply_action(socket, :index, _params) do
    {:ok, assets_balances} =
      Conty.balances_filtered_by_account_type(:assets, %{end_date: Date.utc_today()})

    balances = Taggable.reject(assets_balances, :savings)

    savings = Taggable.filter(assets_balances, :savings)

    {:ok, expenses} =
      Conty.balances_with_source_filtered_by_account_type(:liabilities, %{
        end_date: Timex.end_of_month(Date.utc_today())
      })

    socket =
      assign(socket,
        balances: append_prev_value_to_balance(socket.assigns.balances, balances),
        savings: append_prev_value_to_balance(socket.assigns.savings, savings),
        expenses: append_prev_value_to_balance(socket.assigns.expenses, expenses)
      )

    MateWeb.Endpoint.broadcast_from(self(), @topic, "refresh", socket.assigns)

    socket
  end

  defp apply_action(socket, :new, _params) do
    debit_accounts = Conty.accounts_by_type(:assets) |> to_select
    credit_accounts = Conty.accounts_by_type(:income) |> to_select

    socket
    |> assign(:page_title, "Disponible")
    |> assign(:entry_group, %EntryGroup{start_date: Date.utc_today()})
    |> assign(debit_accounts: debit_accounts)
    |> assign(credit_accounts: credit_accounts)
  end

  defp apply_action(socket, :new_outcome, _params) do
    debit_accounts = Conty.accounts_by_type(:outcome) |> to_select
    credit_accounts = Conty.accounts_by_type(:liabilities) |> to_select

    socket
    |> assign(:page_title, "Gastos")
    |> assign(:entry_group, %EntryGroup{start_date: Date.utc_today()})
    |> assign(debit_accounts: debit_accounts)
    |> assign(credit_accounts: credit_accounts)
  end

  defp apply_action(socket, :move_balance, %{"id" => account_id}) do
    socket
    |> assign(:page_title, "Mover Balance")
    |> assign(:form_component, MateWeb.EntryLive.MoveBalanceComponent)
    |> assign(
      :accounts,
      Conty.accounts_by_type(:assets, except: [account_id]) |> to_select
    )
    |> assign(:account_id, account_id)
    |> assign(:source_id, nil)
    |> assign(:card, nil)
    |> assign(:amount, 0)
    |> assign(:class_name, "bg-primary")
  end

  defp apply_action(socket, :pay, %{"id" => account_id, "source_id" => source_id}) do
    socket
    |> assign(:page_title, "Pagar")
    |> assign(:form_component, MateWeb.EntryLive.MoveBalanceComponent)
    |> assign(:accounts, Conty.accounts_by_type(:assets) |> to_select)
    |> assign(:account_id, account_id)
    |> assign(:source_id, source_id)
    |> assign(:card, :expenses)
    |> assign(:amount, amount_to_pay(account_id, source_id))
    |> assign(:class_name, "bg-danger")
  end

  defp apply_action(socket, :adjust_balance, %{
         "account_debit_id" => account_debit_id,
         "account_credit_id" => account_credit_id,
         "card" => card
       }) do
    card =
      case card do
        "availables" -> :balances
        "savings" -> :savings
        "expenses" -> :expenses
      end

    socket
    |> assign(:page_title, "Saldo en cuenta")
    |> assign(:form_component, MateWeb.EntryLive.AdjustBalanceComponent)
    |> assign(:account_debit_id, account_debit_id)
    |> assign(:account_credit_id, account_credit_id)
    |> assign(:current_balances, socket.assigns[card])
    |> assign(:card, card)
  end

  defp apply_action(socket, :tag_account, %{"id" => account_id, "tag_name" => tag_name}) do
    account = Conty.get_account!(account_id)

    Taggable.tag(account, tag_name)

    socket
    |> push_redirect(to: Routes.page_path(socket, :index))
  end

  defp apply_action(socket, :untag_account, %{"id" => account_id, "tag_name" => tag_name}) do
    account = Conty.get_account!(account_id)

    Taggable.untag(account, tag_name)

    socket
    |> push_redirect(to: Routes.page_path(socket, :index))
  end

  defp append_prev_value_to_balance([], new_balances) do
    Enum.map(new_balances, &%{&1 | prev_amount: &1.amount})
  end

  defp append_prev_value_to_balance(prev_balances, new_balances) do
    for balance <- new_balances do
      prev_balance = Enum.find(prev_balances, &(&1.id == balance.id))

      if is_nil(prev_balance) do
        balance
      else
        %{balance | prev_amount: prev_balance.amount}
      end
    end
  end

  defp amount_to_pay(account_id, source_id) do
    account_id = String.to_integer(account_id)
    source_id = String.to_integer(source_id)

    Enum.find(expenses(), &(&1.account.id == account_id && &1.source.id == source_id))
    |> Map.get(:amount)
    |> Decimal.negate()
  end

  defp expenses do
    {:ok, expenses} =
      Conty.balances_with_source_filtered_by_account_type(:liabilities, %{
        end_date: Timex.end_of_month(Date.utc_today())
      })

    expenses
  end
end

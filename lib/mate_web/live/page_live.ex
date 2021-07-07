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

    {:ok, assets_balances} =
      Conty.balances_filtered_by_account_type(:assets, %{end_date: Date.utc_today()})

    balances = Taggable.reject(assets_balances, :savings)

    savings = Taggable.filter(assets_balances, :savings)

    {:ok, expenses} =
      Conty.balances_with_source_filtered_by_account_type(:liabilities, %{
        end_date: Timex.end_of_month(Date.utc_today())
      })

    {:ok,
     assign(socket,
       balances: balances,
       savings: savings,
       expenses: expenses
     )}
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

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
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
    |> assign(:account_id, account_id)
  end

  defp apply_action(socket, :adjust_balance, %{"account_debit_id" => account_debit_id, "account_credit_id" => account_credit_id, "card" => card}) do
    card =
      case card do
        "available" -> :balances
        "savings" -> :savings
        "expenses" -> :expenses
      end
    socket
    |> assign(:page_title, "Saldo en cuenta")
    |> assign(:form_component, MateWeb.EntryLive.AdjustBalanceComponent)
    |> assign(:account_debit_id, account_debit_id)
    |> assign(:account_credit_id, account_credit_id)
    |> assign(:current_balances, socket.assigns[card])
  end

  defp apply_action(socket, :tag_account, %{"id" => account_id, "tag_name" => tag_name}) do
    account = Conty.get_account!(account_id)

    Taggable.tag(account, tag_name)

    socket
    |> put_flash(:info, "Balance reasignado")
    |> push_redirect(to: Routes.page_path(socket, :index))
  end

  defp apply_action(socket, :untag_account, %{"id" => account_id, "tag_name" => tag_name}) do
    account = Conty.get_account!(account_id)

    Taggable.untag(account, tag_name)

    socket
    |> put_flash(:info, "Balance reasignado")
    |> push_redirect(to: Routes.page_path(socket, :index))
  end
end

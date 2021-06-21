defmodule Mate.Conty do
  @moduledoc """
  The Conty context.
  """

  import Ecto.Query, warn: false
  alias Mate.Repo

  alias Mate.Conty.{Account, Balance, Entry, EntryItem}
  def list_accounts do
    Repo.all(Account)
  end

  def accounts_by_type(type, opts \\ []) do
    except_ids = Keyword.get(opts, :except, [])

    with {:ok, type} <- validate_account_type(type) do
      from(a in Account,
        where: a.type == ^type,
        where: a.id not in ^except_ids
      )
      |> Repo.all()
    end
  end

  def get_account!(id), do: Repo.get!(Account, id)

  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end

  @spec entry_items_by_account(Atom.t(), %{end_date: Date.t()}) ::
          {:ok, [Balance]} | {:error, String.t()}
  def balances_filtered_by_account_type(account_type, %{end_date: end_date}) do
    with {:ok, account_type} <- validate_account_type(account_type) do
      {:ok,
       Repo.all(
         from ei in EntryItem,
           join: a in Account,
           on: ei.account_id == a.id,
           join: e in Entry,
           on: ei.entry_id == e.id,
           where: a.type == ^account_type and e.date <= ^end_date,
           group_by: a.id,
           select: {a, sum(ei.amount)}
       )
       |> Enum.map(fn {account, amount} -> %Balance{account: account, amount: amount} end)}
    end
  end

  defp validate_account_type(type) do
    if type in Ecto.Enum.values(Account, :type) do
      {:ok, type}
    else
      {:error, "Invalid account type"}
    end
  end

  def entry_items_by_account(account_id, %{end_date: end_date}) do
    Repo.all(
      from e in EntryItem,
        where: e.account_id == ^account_id and e.date <= ^end_date
    )
  end

  def balance(entry_items, balance \\ 0)
  def balance([%{amount: amount} | rest], acc), do: balance(rest, acc + amount)
  def balance([], balance), do: balance

  def change_entry(%Entry{} = entry, attrs \\ %{}) do
    entry
    |> Entry.changeset(attrs)
  end
end

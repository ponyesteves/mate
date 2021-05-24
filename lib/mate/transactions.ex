defmodule Mate.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Mate.Repo
  alias Ecto.Multi

  alias Mate.Transactions.EntryGroup
  alias Mate.Conty

  def list_entry_groups do
    Repo.all(EntryGroup)
  end

  def get_entry_group!(id), do: Repo.get!(EntryGroup, id)

  def create_entry_group(attrs \\ %{}) do
    entry_group_changeset = EntryGroup.changeset(%EntryGroup{}, attrs)

    {:ok, %{entry_group: entry_group}} =
      Multi.new()
      |> Multi.insert(:entry_group, entry_group_changeset)
      |> Multi.run(:entry, &create_entry/2)
      |> Repo.transaction()

    {:ok, entry_group}
  end

  defp create_entry(repo, %{entry_group: %EntryGroup{} = entry_group}) do
    entry_attrs = %{
      date: entry_group.start_date,
      type: "Income",
      account_credit_id: entry_group.account_credit_id,
      account_debit_id: entry_group.account_debit_id,
      entry_items: [
        %{amount: entry_group.amount, account_id: entry_group.account_credit_id},
        %{amount: entry_group.amount, account_id: entry_group.account_debit_id}
      ]
    }

    Conty.change_entry(%Conty.Entry{}, entry_attrs)
    |> repo.insert()
  end

  def update_entry_group(%EntryGroup{} = entry_group, attrs) do
    entry_group
    |> EntryGroup.changeset(attrs)
    |> Repo.update()
  end

  def delete_entry_group(%EntryGroup{} = entry_group) do
    Repo.delete(entry_group)
  end

  def change_entry_group(%EntryGroup{} = entry_group, attrs \\ %{}) do
    EntryGroup.changeset(entry_group, attrs)
  end
end

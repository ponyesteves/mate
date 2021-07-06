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

    result =
      Multi.new()
      |> Multi.insert(:entry_group, entry_group_changeset)
      |> Multi.run(:entry, &create_entries/2)
      |> Repo.transaction()

    case result do
      {:ok, %{entry_group: entry_group}} -> {:ok, entry_group}
      {:error, :entry_group, entry_group_changeset, _} -> {:error, entry_group_changeset}
    end
  end

  defp create_entries(repo, multi_struct, periodicity_buffer_count \\ 0)
  defp create_entries(
         repo,
         %{entry_group: %EntryGroup{} = entry_group} = multi_struct,
         periodicity_buffer_count
       )
       when periodicity_buffer_count < entry_group.periodicity_buffer do
    entry_attrs = %{
      date: entry_group.start_date,
      type: "Income",
      entry_group_id: entry_group.id,
      account_credit_id: entry_group.account_credit_id,
      account_debit_id: entry_group.account_debit_id,
      entry_items: [
        %{amount: entry_group.amount, account_id: entry_group.account_credit_id, source_id: entry_group.account_debit_id},
        %{amount: Decimal.negate(entry_group.amount), account_id: entry_group.account_debit_id, source_id: entry_group.account_credit_id}
      ]
    }

    Conty.change_entry(%Conty.Entry{}, entry_attrs)
    |> repo.insert()

    create_entries(repo, multi_struct, periodicity_buffer_count + 1)
  end

  defp create_entries(_repo, _multi_struct, _periodicity_buffer_count), do: {:ok, nil}

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

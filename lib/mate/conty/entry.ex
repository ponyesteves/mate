defmodule Mate.Conty.Entry do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias Mate.Conty.{Account, Entry, EntryItem}

  schema "entries" do
    field :date, :date
    field :type, :string

    belongs_to(:account_credit, Account)
    belongs_to(:account_debit, Account)
    belongs_to(:account_pay, Account)
    belongs_to(:entry_group, Entry)

    has_many(:entry_items, EntryItem)

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:date, :type, :account_credit_id, :account_debit_id, :entry_group_id])
    |> cast_assoc(:entry_items)
    |> validate_required([:date, :type, :account_credit_id, :account_debit_id])
  end
end

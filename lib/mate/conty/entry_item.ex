defmodule Mate.Conty.EntryItem do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias Mate.Conty.{Account, Entry}
  schema "entry_items" do
    field :amount, :decimal

    belongs_to :entry, Entry
    belongs_to :account, Account

    # i.e. the outcome account on a payable
    belongs_to :source, Account

    timestamps()
  end

  @doc false
  def changeset(entry_item, attrs) do
    entry_item
    |> cast(attrs, [:amount, :account_id, :source_id])
    |> validate_required([:amount, :account_id])
  end
end

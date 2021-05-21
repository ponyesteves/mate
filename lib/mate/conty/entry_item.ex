defmodule Mate.Conty.EntryItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entry_items" do
    field :amount, :decimal
    field :entry_id, :id
    field :account_id, :id

    timestamps()
  end

  @doc false
  def changeset(entry_item, attrs) do
    entry_item
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
  end
end

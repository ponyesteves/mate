defmodule Mate.Transactions.EntryGroup do
  @moduledoc """
    EntryGroup contains all the info for creating entries.
    We don't create entries directly, we always use this wrapper
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Mate.Conty.Account

  schema "entry_groups" do
    field :status, :string, default: "active"
    field :start_date, :date
    field :end_date, :date
    field :amount, :decimal
    field :recurrent, :boolean, default: false
    field :periodicity, :integer
    field :periodicity_buffer, :integer
    field :periodicity_type, :string

    belongs_to :account_debit, Account
    belongs_to :account_credit, Account
    belongs_to :account_pay, Account

    timestamps()
  end

  @doc false
  def changeset(entry_group, attrs) do
    entry_group
    |> cast(attrs, [:start_date, :end_date, :amount, :recurrent, :periodicity_type, :periodicity, :periodicity_buffer, :account_debit_id, :account_credit_id])
    |> validate_required([:status, :amount, :start_date, :end_date, :recurrent, :periodicity_type, :periodicity, :periodicity_buffer, :account_debit_id, :account_credit_id])
  end
end

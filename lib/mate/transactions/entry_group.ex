defmodule Mate.Transactions.EntryGroup do
  @moduledoc """
    EntryGroup contains all the info for creating entries.
    We don't create entries directly, we always use this wrapper
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Mate.Conty.{Account, Entry}

  schema "entry_groups" do
    field :status, :string, default: "active"
    field :start_date, :date
    field :end_date, :date
    field :amount, :decimal
    field :recurrent, :boolean, default: false
    field :periodicity, :integer, default: 1
    field :periodicity_buffer, :integer, default: 1
    field :periodicity_type, Ecto.Enum, values: ~w(day month year)a, default: :month

    has_many :entries, Entry

    belongs_to :account_debit, Account
    belongs_to :account_credit, Account
    belongs_to :account_pay, Account

    timestamps()
  end

  @doc false
  def changeset(entry_group, attrs) do
    entry_group
    |> cast(attrs, [:start_date, :end_date, :amount, :recurrent, :periodicity_type, :periodicity, :periodicity_buffer, :account_debit_id, :account_credit_id])
    |> validate_required([:status, :amount, :start_date, :recurrent, :periodicity_type, :periodicity, :periodicity_buffer, :account_debit_id, :account_credit_id])
  end
end

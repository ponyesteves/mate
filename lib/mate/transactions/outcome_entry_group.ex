defmodule Mate.Transactions.OutcomeEntryGroup do
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
    field :require_end_date, :boolean, default: false, virtual: true
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
    |> cast(attrs, [
      :start_date,
      :end_date,
      :amount,
      :recurrent,
      :periodicity_type,
      :periodicity,
      :periodicity_buffer,
      :account_debit_id,
      :account_credit_id,
      :require_end_date
    ])
    |> validate_required([
      :status,
      :amount,
      :start_date,
      :recurrent,
      :periodicity_type,
      :periodicity,
      :periodicity_buffer,
      :account_debit_id,
      :account_credit_id
    ])
    |> validate_end_date
  end

  def validate_end_date(changeset) do
    require_end_date = get_field(changeset, :require_end_date)

    if require_end_date do
      validate_required(changeset, [:end_date])
    else
      changeset
    end
  end
end

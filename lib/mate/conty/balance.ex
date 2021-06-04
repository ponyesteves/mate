defmodule Mate.Conty.Balance do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias Mate.Conty.Account

  embedded_schema do
    field :amount, :decimal

    belongs_to :account, Account
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:amount, :account_id])
    |> validate_required([:amount, :account_id])
  end
end

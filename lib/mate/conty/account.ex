defmodule Mate.Conty.Account do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :name, :string
    field :type, Ecto.Enum, values: ~w(assets liabilities equity income outcome)a

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :type])
    |> validate_required([:name, :type])
    |> validate_inclusion(:type, Ecto.Enum.values(__MODULE__, :type))
  end
end

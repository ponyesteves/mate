defmodule Mate.Conty.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entries" do
    field :date, :date

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:date])
    |> validate_required([:date])
  end
end

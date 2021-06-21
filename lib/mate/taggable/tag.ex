defmodule Mate.Taggable.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  alias Mate.Taggable.{Type, Name}

  schema "tags" do
    field :name, Name
    field :taggable_type, Type

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :taggable_type])
    |> validate_required([:name, :taggable_type])
    |> unique_constraint([:name, :taggable_type])
  end
end

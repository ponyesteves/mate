defmodule Mate.Taggable.Tagging do
  use Ecto.Schema
  import Ecto.Changeset

  schema "taggings" do
    field :taggable_id, :integer
    field :tag_id, :id

    field :taggable_type, :string
    timestamps()
  end

  @doc false
  def changeset(tagging, attrs) do
    tagging
    |> cast(attrs, [:taggable_id])
    |> validate_required([:taggable_id])
  end
end

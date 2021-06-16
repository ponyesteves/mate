defmodule Mate.Taggable.Tagging do
  use Ecto.Schema
  import Ecto.Changeset

  alias Mate.Taggable.Tag

  schema "taggings" do
    field :taggable_id, :integer
    field :taggable_type, :string

    belongs_to :tag, Tag
    timestamps()
  end

  @doc false
  def changeset(tagging, attrs) do
    tagging
    |> cast(attrs, [:tag_id, :taggable_id, :taggable_type])
    |> validate_required([:tag_id, :taggable_id, :taggable_type])
  end
end

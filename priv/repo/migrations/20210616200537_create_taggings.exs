defmodule Mate.Repo.Migrations.CreateTaggings do
  use Ecto.Migration

  def change do
    create table(:taggings) do
      add :taggable_type, :string
      add :taggable_id, :integer
      add :tag_id, references(:tags, on_delete: :nothing)
      timestamps()
    end

    create index(:taggings, [:tag_id])
  end
end

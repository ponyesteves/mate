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
    create unique_index(:taggings, [:tag_id, :taggable_id, :taggable_type])
  end
end

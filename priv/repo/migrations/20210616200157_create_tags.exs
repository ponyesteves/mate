defmodule Mate.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string
      add :taggable_type, :string

      timestamps()
    end

    create unique_index(:tags, [:name, :taggable_type])
  end
end

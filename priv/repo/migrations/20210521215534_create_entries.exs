defmodule Mate.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :date, :date

      timestamps()
    end

  end
end

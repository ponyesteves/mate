defmodule Mate.Repo.Migrations.CreateEntryItems do
  use Ecto.Migration

  def change do
    create table(:entry_items) do
      add :amount, :decimal
      add :entry_id, references(:entries, on_delete: :delete_all)
      add :account_id, references(:accounts, on_delete: :nothing)

      timestamps()
    end

    create index(:entry_items, [:entry_id])
    create index(:entry_items, [:account_id])
  end
end

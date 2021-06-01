defmodule Mate.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :date, :date
      add :type, :string

      add :account_credit_id, references(:accounts, on_delete: :nothing)
      add :account_debit_id, references(:accounts, on_delete: :nothing)
      add :entry_group_id, references(:entry_groups, on_delete: :delete_all)

      timestamps()
    end

  end
end

defmodule Mate.Repo.Migrations.CreateEntryGroups do
  use Ecto.Migration

  def change do
    create table(:entry_groups) do
      add :status, :string
      add :amount, :decimal
      add :start_date, :date
      add :end_date, :date
      add :recurrent, :boolean, default: false, null: false
      add :periodicity_type, :string
      add :periodicity, :integer
      add :periodicity_buffer, :integer
      add :account_debit_id, references(:accounts, on_delete: :nothing)
      add :account_credit_id, references(:accounts, on_delete: :nothing)
      add :account_pay_id, references(:accounts, on_delete: :nothing)

      timestamps()
    end

    create index(:entry_groups, [:account_debit_id])
    create index(:entry_groups, [:account_credit_id])
    create index(:entry_groups, [:account_pay_id])
  end
end

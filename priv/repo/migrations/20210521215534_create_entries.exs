defmodule Mate.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :date, :date
      add :type, :string

      add :account_credit_id, references(:accounts, on_delete: :nothing)
      add :account_debit_id, references(:accounts, on_delete: :nothing)
      add :account_pay_id, references(:accounts, on_delete: :nothing)

      timestamps()
    end

  end
end

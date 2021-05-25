defmodule Mate.TransactionsTest do
  use Mate.DataCase

  alias Mate.Transactions
  alias Mate.Conty.{Entry, EntryItem}
  import Ecto.Query

  setup do
    {:ok, bank} = Mate.Conty.create_account(%{name: "Bank", type: "assets"})
    {:ok, income} = Mate.Conty.create_account(%{name: "Income", type: "income"})
    # {:ok, receivable} = Mate.Conty.create_account(%{name: "Receivable", type: "assets"})
    # {:ok, payable} = Mate.Conty.create_account(%{name: "Receivable", type: "liabilities"})
    {:ok, bank_account: bank, income_account: income}
  end

  describe "entry_groups" do
    alias Mate.Transactions.EntryGroup

    @valid_attrs %{
      amount: "120.5",
      end_date: ~D[2010-04-17],
      periodicity: 42,
      periodicity_buffer: 2,
      periodicity_type: "some periodicity_type",
      recurrent: true,
      start_date: ~D[2010-04-17]
    }

    def entry_group_fixture(attrs \\ %{}) do
      attrs
      |> Enum.into(@valid_attrs)
      |> Transactions.create_entry_group()
    end

    test "create_entry_group/1 creates a entry_group and entries", %{
      bank_account: bank_account,
      income_account: income_account
    } do
      assert {:ok, %EntryGroup{}} =
               entry_group_fixture(%{
                 periodicity_buffer: 1,
                 account_credit_id: bank_account.id,
                 account_debit_id: income_account.id
               })

      assert Repo.one(from e in Entry, select: count(e)) == 1
      assert Repo.one(from e in EntryItem, select: count(e)) == 2
    end

    test "create_entry_group/1 creates a entry_group and 2 entries according to buffer", %{
      bank_account: bank_account,
      income_account: income_account
    } do
      assert {:ok, %EntryGroup{}} =
               entry_group_fixture(%{
                 periodicity_buffer: 2,
                 account_credit_id: bank_account.id,
                 account_debit_id: income_account.id
               })

      assert Repo.one(from e in Entry, select: count(e)) == 2
      assert Repo.one(from e in EntryItem, select: count(e)) == 4
    end
  end
end

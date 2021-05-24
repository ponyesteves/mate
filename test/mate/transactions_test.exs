defmodule Mate.TransactionsTest do
  use Mate.DataCase

  alias Mate.Transactions

  setup do
    {:ok, account } = Mate.Conty.create_account(%{name: "test", type: "assets"})
    {:ok, account: account}
  end

  describe "entry_groups" do
    alias Mate.Transactions.EntryGroup

    @valid_attrs %{amount: "120.5", end_date: ~D[2010-04-17], periodicity: 42, periodicity_buffer: 42, periodicity_type: "some periodicity_type", recurrent: true, start_date: ~D[2010-04-17], status: "some status"}
    @update_attrs %{amount: "456.7", end_date: ~D[2011-05-18], periodicity: 43, periodicity_buffer: 43, periodicity_type: "some updated periodicity_type", recurrent: false, start_date: ~D[2011-05-18], status: "some updated status"}
    @invalid_attrs %{amount: nil, end_date: nil, periodicity: nil, periodicity_buffer: nil, periodicity_type: nil, recurrent: nil, start_date: nil, status: nil}

    def entry_group_fixture(attrs \\ %{}) do
      {:ok, entry_group, entry} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transactions.create_entry_group()

      entry_group
    end

    test "create_entry_group/1 with valid data creates a entry_group", %{account: account} do
      assert {:ok, %EntryGroup{} = entry_group} = entry_group_fixture(%{
      account_credit_id: account.id, account_debit_id: account.id})
      assert entry_group.amount == Decimal.new("120.5")
      assert entry_group.end_date == ~D[2010-04-17]
      assert entry_group.periodicity == 42
      assert entry_group.periodicity_buffer == 42
      assert entry_group.periodicity_type == "some periodicity_type"
      assert entry_group.recurrent == true
      assert entry_group.start_date == ~D[2010-04-17]
      assert entry_group.status == "some status"
    end

  end
end

defmodule Mate.TransactionsTest do
  use Mate.DataCase

  alias Mate.Transactions

  describe "entry_groups" do
    alias Mate.Transactions.EntryGroup

    @valid_attrs %{amount: "120.5", end_date: ~D[2010-04-17], periodicity: 42, periodicity_buffer: 42, periodicity_type: "some periodicity_type", recurrent: true, start_date: ~D[2010-04-17], status: "some status"}
    @update_attrs %{amount: "456.7", end_date: ~D[2011-05-18], periodicity: 43, periodicity_buffer: 43, periodicity_type: "some updated periodicity_type", recurrent: false, start_date: ~D[2011-05-18], status: "some updated status"}
    @invalid_attrs %{amount: nil, end_date: nil, periodicity: nil, periodicity_buffer: nil, periodicity_type: nil, recurrent: nil, start_date: nil, status: nil}

    def entry_group_fixture(attrs \\ %{}) do
      {:ok, entry_group} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transactions.create_entry_group()

      entry_group
    end

    test "list_entry_groups/0 returns all entry_groups" do
      entry_group = entry_group_fixture()
      assert Transactions.list_entry_groups() == [entry_group]
    end

    test "get_entry_group!/1 returns the entry_group with given id" do
      entry_group = entry_group_fixture()
      assert Transactions.get_entry_group!(entry_group.id) == entry_group
    end

    test "create_entry_group/1 with valid data creates a entry_group" do
      assert {:ok, %EntryGroup{} = entry_group} = Transactions.create_entry_group(@valid_attrs)
      assert entry_group.amount == Decimal.new("120.5")
      assert entry_group.end_date == ~D[2010-04-17]
      assert entry_group.periodicity == 42
      assert entry_group.periodicity_buffer == 42
      assert entry_group.periodicity_type == "some periodicity_type"
      assert entry_group.recurrent == true
      assert entry_group.start_date == ~D[2010-04-17]
      assert entry_group.status == "some status"
    end

    test "create_entry_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_entry_group(@invalid_attrs)
    end

    test "update_entry_group/2 with valid data updates the entry_group" do
      entry_group = entry_group_fixture()
      assert {:ok, %EntryGroup{} = entry_group} = Transactions.update_entry_group(entry_group, @update_attrs)
      assert entry_group.amount == Decimal.new("456.7")
      assert entry_group.end_date == ~D[2011-05-18]
      assert entry_group.periodicity == 43
      assert entry_group.periodicity_buffer == 43
      assert entry_group.periodicity_type == "some updated periodicity_type"
      assert entry_group.recurrent == false
      assert entry_group.start_date == ~D[2011-05-18]
      assert entry_group.status == "some updated status"
    end

    test "update_entry_group/2 with invalid data returns error changeset" do
      entry_group = entry_group_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_entry_group(entry_group, @invalid_attrs)
      assert entry_group == Transactions.get_entry_group!(entry_group.id)
    end

    test "delete_entry_group/1 deletes the entry_group" do
      entry_group = entry_group_fixture()
      assert {:ok, %EntryGroup{}} = Transactions.delete_entry_group(entry_group)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_entry_group!(entry_group.id) end
    end

    test "change_entry_group/1 returns a entry_group changeset" do
      entry_group = entry_group_fixture()
      assert %Ecto.Changeset{} = Transactions.change_entry_group(entry_group)
    end
  end
end

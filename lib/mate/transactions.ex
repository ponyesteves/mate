defmodule Mate.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Mate.Repo

  alias Mate.Transactions.EntryGroup

  @doc """
  Returns the list of entry_groups.

  ## Examples

      iex> list_entry_groups()
      [%EntryGroup{}, ...]

  """
  def list_entry_groups do
    Repo.all(EntryGroup)
  end

  @doc """
  Gets a single entry_group.

  Raises `Ecto.NoResultsError` if the Entry group does not exist.

  ## Examples

      iex> get_entry_group!(123)
      %EntryGroup{}

      iex> get_entry_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_entry_group!(id), do: Repo.get!(EntryGroup, id)

  @doc """
  Creates a entry_group.

  ## Examples

      iex> create_entry_group(%{field: value})
      {:ok, %EntryGroup{}}

      iex> create_entry_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_entry_group(attrs \\ %{}) do
    %EntryGroup{}
    |> EntryGroup.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a entry_group.

  ## Examples

      iex> update_entry_group(entry_group, %{field: new_value})
      {:ok, %EntryGroup{}}

      iex> update_entry_group(entry_group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_entry_group(%EntryGroup{} = entry_group, attrs) do
    entry_group
    |> EntryGroup.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a entry_group.

  ## Examples

      iex> delete_entry_group(entry_group)
      {:ok, %EntryGroup{}}

      iex> delete_entry_group(entry_group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_entry_group(%EntryGroup{} = entry_group) do
    Repo.delete(entry_group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking entry_group changes.

  ## Examples

      iex> change_entry_group(entry_group)
      %Ecto.Changeset{data: %EntryGroup{}}

  """
  def change_entry_group(%EntryGroup{} = entry_group, attrs \\ %{}) do
    EntryGroup.changeset(entry_group, attrs)
  end
end

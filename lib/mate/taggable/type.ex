defmodule Mate.Taggable.Type do
  use Ecto.Type
  def type, do: :string

  def cast(taggable_type) when is_binary(taggable_type), do: {:ok, taggable_type}

  def cast(taggable_type) when is_atom(taggable_type), do: {:ok, Atom.to_string(taggable_type)}

  # Everything else is a failure though
  def cast(_), do: :error

  def dump(taggable_type), do: {:ok, taggable_type}
  def load(taggable_type), do: {:ok, taggable_type}
end

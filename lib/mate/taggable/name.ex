defmodule Mate.Taggable.Name do
  use Ecto.Type
  def type, do: :string

  def cast(name) when is_binary(name), do: {:ok, Macro.underscore(name)}

  def cast(name) when is_atom(name), do: {:ok, Atom.to_string(name)}

  # Everything else is a failure though
  def cast(_), do: :error

  def dump(name), do: {:ok, name}
  def load(name), do: {:ok, String.to_atom(name)}
end

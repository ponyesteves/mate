defmodule Mate.EnumHelpers do
  @moduledoc false
  def totalize(enumerable, key) do
    Enum.map(enumerable, &(Map.get(&1, key)))
    |> Enum.reduce(0, fn x, acc -> Decimal.add(x || 0, acc) end)
  end
end


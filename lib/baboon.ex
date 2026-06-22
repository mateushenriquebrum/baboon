defmodule Baboon do
  defmodule Transacation do
    defstruct [:seq, :timestamp]
  end

  defmodule Datom do
    defstruct [:entity, :attribute, :value, :transaction, :promisse]
  end

  def with_transaction(datoms, transaction),
    do: datoms |> Enum.map(&%{&1 | transaction: transaction})

  def datoms_to_entity(same_entity_datoms) do
    same_entity_datoms
    |> Enum.sort_by(fn %{transaction: %{seq: tx}} -> tx end)
    |> Enum.reduce(%{}, fn %{attribute: a, value: v, entity: e}, entity ->
      entity
      |> Map.put(a, v)
      |> Map.put(:entity, e)
    end)
  end
end

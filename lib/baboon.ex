defmodule Baboon do
  defmodule Transacation do
    defstruct [:seq, :timestamp]
  end

  defmodule Datom do
    defstruct [:entity, :attribute, :value, :promisse, transaction: %Transacation{}]
  end

  defmodule Live do
    defstruct [:eavt]
  end

  defmodule Database do
    defstruct live: %Live{}
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

  def make_eavt_index(datoms) when datoms == [], do: []

  def make_eavt_index(datoms, opts \\ [size: 1]) do
    # List.duplicate(0, opts |> Keyword.get(:size))
    entities = datoms |> Enum.map(& &1.entity) |> Enum.uniq()
    %{node: entities}
  end
end

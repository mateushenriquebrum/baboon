defmodule Baboon do
  defmodule Transacation do
    defstruct [:transaction, :timestamp]
  end

  defmodule Datom do
    defstruct [:entity, :property, :value, :transaction, :promisse]
  end

  def with_transaction(datoms, transaction),
    do: datoms |> Enum.map(&%{&1 | transaction: transaction})

  def hidrate(datoms) do
    datoms |> Enum.sort()
  end
end

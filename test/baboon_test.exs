defmodule BaboonTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Baboon.Transacation
  alias Baboon.Datom

  doctest Baboon

  property "apply transaction for every datom" do
    check all(datoms <- list_of(datom_generator()), transaction <- transaction_generator()) do
      assert datoms
             |> Baboon.with_transaction(transaction)
             |> Enum.all?(fn %{transaction: tx} -> tx == transaction end)
    end
  end

  property "should hidrate with latest updates" do
    check all(datoms <- list_of(datom_generator())) do
      datoms |> Baboon.hidrate()
      # hidrate should return as many unique entities generated
      # hidrate should return the last properties of a entity if promisse is assert
      # hidrate should remove the property if last promisse is retreated
    end
  end

  defp datom_generator do
    gen all(
          entity <- integer(0..50),
          property <-
            member_of([
              [:person, :id],
              [:person, :name],
              [:person, :age],
              [:person, :created_at],
              [:person, :updated_at],
              [:person, :member_since]
            ]),
          value <- string(:ascii),
          promisse <- member_of([:assert, :retract])
        ) do
      %Datom{entity: entity, property: property, value: value, promisse: promisse}
    end
  end

  defp transaction_generator do
    gen(
      all(
        id <- integer(0..10_000_000),
        unix_timestamp <- integer(100_000_000..10_000_000_000)
      ) do
        timestamp = unix_timestamp |> DateTime.from_unix()
        %Transacation{transaction: id, timestamp: timestamp}
      end
    )
  end
end

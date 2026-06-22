defmodule BaboonTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Baboon.Transacation
  alias Baboon.Datom

  doctest Baboon

  property "should apply transaction for every datom" do
    check all(
            entity <- integer(1..100),
            datoms <- list_of(datom_generator(entity)),
            transaction <- transaction_generator()
          ) do
      assert datoms
             |> Baboon.with_transaction(transaction)
             |> Enum.all?(fn %{transaction: tx} -> tx == transaction end)
    end
  end

  property "should convert datoms to entity" do
    check all(
            entity <- integer(1..100),
            datoms <- list_of(datom_generator(entity))
          ) do
      ## datoms |> IO.inspect()
      datoms |> Baboon.datoms_to_entity()

      datoms
      |> Enum.sort_by(fn %{transaction: %{seq: tx}} -> tx end)
      |> Enum.reduce(%{}, fn %{attribute: key} = datom, acc -> Map.put(acc, key, datom) end)
      |> Map.values()
      |> IO.inspect()

      # hidrate should return as many unique entities generated
      # hidrate should return the last properties of a entity if promisse is assert
      # hidrate should remove the property if last promisse is retreated
    end
  end

  defp datom_generator(entity) do
    gen all(
          attribute <-
            member_of([
              :person_id,
              :person_name,
              :person_age,
              :person_created_at,
              :person_updated_at,
              :person_member_since
            ]),
          value <- string(:ascii),
          promisse <- member_of([:assert, :retract]),
          transaction <- transaction_generator(1..5)
        ) do
      %Datom{
        entity: entity,
        attribute: attribute,
        value: value,
        transaction: transaction,
        promisse: promisse
      }
    end
  end

  defp transaction_generator(size \\ 0..10_000_000) do
    gen(
      all(
        seq <- integer(size),
        unix_timestamp <- integer(100_000_000..10_000_000_000)
      ) do
        timestamp = unix_timestamp |> DateTime.from_unix()
        %Transacation{seq: seq, timestamp: timestamp}
      end
    )
  end
end

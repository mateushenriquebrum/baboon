defmodule BaboonTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Baboon.Transacation
  alias Baboon.Datom

  doctest Baboon

  property "should apply transaction for every fact" do
    check all(
            entity <- integer(1..100),
            datoms <- list_of(datom_generator(entity)),
            transaction <- transaction_generator()
          ) do
      assert datoms
             |> Baboon.with_transaction(transaction)
             |> Enum.all?(&(&1.transaction == transaction))
    end
  end

  property "should convert datoms to entity" do
    check all(
            entity <- integer(1..100),
            datoms <- list_of(datom_generator(entity))
          ) do
      object = datoms |> Baboon.datoms_to_entity()

      datoms
      |> Enum.sort_by(& &1.transaction.seq)
      |> Enum.reduce(%{}, &Map.put(&2, &1.attribute, &1))
      |> Map.values()
      |> Enum.all?(fn %{entity: entity, attribute: attribute, value: value} ->
        assert Map.get(object, attribute) == value
        assert object.entity == entity
      end)
    end
  end

  describe "should compute eavt index for live query" do
    property "for empty datoms" do
      assert Baboon.make_eavt_index([]) == []
    end

    property "for single entity datoms then b-tree node size should be 1" do
      check all(
              size <- integer(1..100),
              datoms <- list_of(datom_generator(999), length: size)
            ) do
        %{node: node} = Baboon.make_eavt_index(datoms, size: size)
        assert length(node) == 1
      end
    end

    # high(datom(node_size * k)) == k
    # high(datom(node_size/n * k)) == k
    # <eavt(a<n>)> = <eavt(b<n>)>
    # for all node its left child node < parents
    # for all node its right child node > parents
    # eavt(a + b) = eavt (b + a)
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
          value <- term(),
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
        {:ok, ts} = unix_timestamp |> DateTime.from_unix()
        %Transacation{seq: seq, timestamp: ts}
      end
    )
  end
end

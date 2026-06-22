defmodule MemoryTransactorTest do
  use ExUnit.Case
  use ExUnitProperties

  property "should it increase transaction seq when datoms are transacted" do
    check all(n <- integer(1..20)) do
      {:ok, pid} = MemoryTransactor.start_link()
      m = MemoryTransactor.current_transaction_id()

      Enum.each(1..n, fn _ ->
        MemoryTransactor.next_transaction_id()
        assert MemoryTransactor.current_transaction_id() > m
      end)

      assert MemoryTransactor.current_transaction_id() == n
      GenServer.stop(pid)
    end
  end
end

defmodule MemoryTransactorTest do
  use ExUnit.Case

  setup do
    {:ok, pid} = MemoryTransactor.start_link()
    %{pid: pid}
  end

  test "it increase transaction id when datoms are provided" do
    [%{transaction: transaction} | _] = MemoryTransactor.transact([%Baboon.Datom{}])
    assert 0 == transaction.transaction
    [%{transaction: transaction} | _] = MemoryTransactor.transact([%Baboon.Datom{}])
    assert 1 == transaction.transaction
  end
end

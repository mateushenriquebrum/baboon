defmodule MemoryTransactorTest do
  use ExUnit.Case

  setup do
    {:ok, pid} = MemoryTransactor.start_link()
    %{pid: pid}
  end

  test "should it increase transaction seq when datoms are transacted" do
    [%{transaction: %{seq: seq}} | _] = MemoryTransactor.transact([%Baboon.Datom{}])
    assert 0 == seq
    [%{transaction: %{seq: seq}} | _] = MemoryTransactor.transact([%Baboon.Datom{}])
    assert 1 == seq
  end
end

defmodule MemoryTransactor do
  use GenServer
  alias Baboon.Transacation

  # Client
  def transact(datoms) do
    GenServer.call(__MODULE__, %{transact: datoms})
  end

  def start_link(initial \\ 0) do
    GenServer.start_link(__MODULE__, initial, name: __MODULE__)
  end

  # Server
  @impl true
  def init(initial \\ 0) do
    {:ok, initial}
  end

  @impl true
  def handle_call(%{transact: datoms}, _from, count) when datoms != [] do
    {:reply,
     datoms
     |> Baboon.with_transaction(%Transacation{timestamp: DateTime.utc_now(), transaction: count}),
     count + 1}
  end

  @impl true
  def handle_call(%{transact: datoms}, _from, count) when datoms == [] do
    {:reply, datoms, count}
  end
end

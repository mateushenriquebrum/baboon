defmodule MemoryTransactor do
  use GenServer

  # Client
  def next_transaction_id() do
    GenServer.call(__MODULE__, :next)
  end

  def current_transaction_id() do
    GenServer.call(__MODULE__, :current)
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
  def handle_call(:next, _from, count) do
    {:reply, count, count + 1}
  end

  @impl true
  def handle_call(:current, _from, count) do
    {:reply, count, count}
  end
end

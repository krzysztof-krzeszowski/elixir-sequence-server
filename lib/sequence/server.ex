defmodule Sequence.Server do
  use GenServer

  # API
  def start_link(stash_pid) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
  end

  def next_number do
    GenServer.call(__MODULE__, :next_number)
  end

  def increment_number(delta) do
    GenServer.cast(__MODULE__, {:increment_number, delta})
  end

  def pop do
    GenServer.call(__MODULE__, :pop)
  end
  
  def push(val) do
    GenServer.cast(__MODULE__, {:push, val})
  end

  # implementation
  def init stash_pid do
    current_number = Sequence.Stash.get_value stash_pid
    { :ok, {current_number, stash_pid} }
  end
  def handle_call(:next_number, _from, {current_number, stash_pid}) do
    { :reply, current_number, {current_number + 1, stash_pid} }
  end

  def handle_call(:pop, _from, {[], stash_pid}) do
    { :reply, :empty, {[], stash_pid} }
  end
  def handle_call(:pop, _from, {[h | t], stash_pid}) do
    { :reply, h, {t, stash_pid} }
  end

  def handle_cast({:push, val}, {list, stash_pid}) do
    { :noreply, {[val | list], stash_pid} }
  end

  def handle_cast({:increment_number, delta}, {current_number, stash_pid}) do
    { :noreply, {current_number + delta, stash_pid} }
  end

  def terminate(_reason, {current_number, stash_pid}) do
    Sequence.Stash.save_value stash_pid, current_number
  end
end

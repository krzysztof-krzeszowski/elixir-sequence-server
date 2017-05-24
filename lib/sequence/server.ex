defmodule Sequence.Server do
  use GenServer
  
  def handle_call(:next_number, _from, current_number) do
    { :reply, current_number, current_number + 1 }
  end

  def handle_call(:pop, _from, []) do
    { :reply, :empty, [] }
  end
  def handle_call(:pop, _from, [h | t]) do
    { :reply, h, t }
  end
end

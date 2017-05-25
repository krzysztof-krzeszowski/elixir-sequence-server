defmodule Sequence.Supervisor do
  use Supervisor
  def start_link init do
    result = { :ok, sup } = Supervisor.start_link(__MODULE__, [init])
    start_workers(sup, init)
    result
  end

  def start_workers sup, init do
    # stash worker
    {:ok, stash} = 
      Supervisor.start_child(sup, worker(Sequence.Stash, [init]))
    # actual worker
    Supervisor.start_child(sup, supervisor(Sequence.SubSupervisor, [stash]))
  end

  def init _ do
    supervise [], strategy: :one_for_one
  end
end

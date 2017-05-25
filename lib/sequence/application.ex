defmodule Sequence.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    {:ok, _pid} = Sequence.Supervisor.start_link(123)
  end
end

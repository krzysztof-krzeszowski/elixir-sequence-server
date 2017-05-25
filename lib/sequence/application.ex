defmodule Sequence.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    {:ok, _pid} = Application.get_env(:sequence, :initial_number)
    |> Sequence.Supervisor.start_link
  end
end

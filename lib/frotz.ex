defmodule Frotz do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
       worker(FrotzServer, [[name: FrotzServerPID]])
    ]

    opts = [strategy: :one_for_one, name: Frotz.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule FrotzAgent do
  alias Porcelain.Process, as: Proc
  alias Porcelain.Result

  def start_link(options) do
    Agent.start_link (fn -> init(options) end)
  end

  defp init(options) do
    proc = %Proc{pid: pid} = Porcelain.spawn("sh", ["--noediting", "-i"], in: :receive, out: {:send, self()})
    Map.merge options, %{proc: proc}
  end

  def start(agent) do
    Agent.get(agent, fn state -> exec(state[:proc], "#{state[:frotz_path]} #{state[:game_path]}\n") end)
  end

  def command(agent, command) do
    Agent.get(agent, fn (state) -> exec(state[:proc], command) end)
  end

  defp exec(proc, command) do
    IO.puts "executing: #{command}"
    Proc.send_input(proc, command)
    receive do
      {pid, :data, :out, data} -> data
    after
      5000 -> :timeout
    end
  end
end

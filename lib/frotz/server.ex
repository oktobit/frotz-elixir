defmodule FrotzServer do
  use GenServer

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Looks up the game pid for `game` stored in `server`.

  Returns `{:ok, pid}` if the game exists, `:error` otherwise.
  """
  def lookup(server, game) do
    GenServer.call(server, {:lookup, game})
  end

  @doc """
  Ensures there is a game associated to the given `game` in `server`.
  """
  def create(server, game) do
    GenServer.call(server, {:create, game})
  end

  def start(server, game) do
    GenServer.call(server, {:start, game})
  end

  def command(server, game, command) do
    GenServer.call(server, {:command, game, command})
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, HashDict.new}
  end

  def handle_call({:lookup, game}, _from, games) do
    {:reply, HashDict.fetch(games, game), games}
  end

  def handle_call({:create, game}, _from, games) do
    if HashDict.has_key?(games, game) do
      {:reply, games}
    else
      options = %{
        frotz_path: " ~/frotz/dfrotz",
        game_path: "~/frotz/ZORK1.DAT"
      }
      {:ok, agent} = FrotzAgent.start_link(options)
      {:reply, :ok, HashDict.put(games, game, agent)}
    end
  end

  def handle_call({:start, game}, _from, games) do
    if HashDict.has_key?(games, game) do
      agent = HashDict.get(games, game)
      FrotzAgent.start(agent)
      {:reply, :ok, games}
    else 
      {:error, :not_found}
    end
  end

  def handle_call({:command, game, command}, _from, games) do
    if HashDict.has_key?(games, game) do
      agent = HashDict.get(games, game)
      response = FrotzAgent.command(agent, command)
      {:reply, response, games}
    else 
      {:error, :not_found}
    end
  end
end

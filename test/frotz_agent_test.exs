defmodule FrotzAgentTest do
  use ExUnit.Case, async: true

  setup do
    options = %{
      frotz_path: " ~/frotz/dfrotz",
      game_path: "~/frotz/ZORK1.DAT"
    }

    {:ok, agent} = FrotzAgent.start_link(options)
    {:ok, agent: agent}
  end

  test "start link", %{agent: agent} do
    assert agent
  end

  test "start game", %{agent: agent} do
    assert FrotzAgent.start(agent) == " West of House                               Score: 0        Moves: 0\n\nZORK I: The Great Underground Empire\nCopyright (c) 1981, 1982, 1983 Infocom, Inc. All rights reserved.\nZORK is a registered trademark of Infocom, Inc.\nRevision 88 / Serial number 840726\n\nWest of House\nYou are standing in an open field west of a white house, with a boarded\nfront door.\nThere is a small mailbox here.\n\n>"
  end

  test "send command", %{agent: agent} do
    FrotzAgent.start(agent)
    assert FrotzAgent.command(agent, "open mailbox\n") == " West of House                               Score: 0        Moves: 1\n\nOpening the small mailbox reveals a leaflet.\n\n>"
  end
end


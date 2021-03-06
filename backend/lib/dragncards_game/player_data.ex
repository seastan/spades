defmodule DragnCardsGame.PlayerData do
  @moduledoc """
  Represents a player.
  """
  alias DragnCardsGame.{PlayerData}

  @type t :: Map.t()

  @doc """
  new/1:  Create a player.
  """
  @spec new() :: PlayerData.t()
  def new() do
    %{
      "threat" => 0,
      "willpower" => 0,
      "eliminated" => false,
      "cardsDrawn" => 1,
      "arrows" => [],
      "visibleHand" => false,
      "refreshed" => true,
    }
  end

end

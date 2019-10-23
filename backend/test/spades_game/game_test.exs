defmodule GameTest do
  use ExUnit.Case, async: true

  doctest SpadesGame.Game
  alias SpadesGame.{Game, GameOptions, Card}

  setup do
    {:ok, options} = GameOptions.validate(%{"hardcoded_cards" => true})
    %{options: options}
  end

  describe "new/1" do
    test "returns a game" do
      game = Game.new("new1")
      assert game.draw |> length == 52
      assert game.discard == []
      assert game.west.hand |> length == 13
      assert game.east.hand |> length == 13
      assert game.north.hand |> length == 13
      assert game.south.hand |> length == 13
    end
  end

  describe "new/2" do
    test "returns a game", %{options: options} do
      game = Game.new("new2", options)
      assert game.draw |> length == 52
      assert game.discard == []
      assert game.west.hand |> length == 13
      assert game.east.hand |> length == 13
      assert game.north.hand |> length == 13
      assert game.south.hand |> length == 13

      # Test Hardcoded Cards
      assert game.west.hand |> Enum.member?(%Card{rank: 7, suit: :h})
      assert game.north.hand |> Enum.member?(%Card{rank: 2, suit: :h})
    end
  end

  describe "discard/1" do
    test "discards a card", %{options: options} do
      game = Game.new("discard1", options)
      game2 = Game.discard(game)
      game3 = Game.discard(game2)

      assert game2.draw |> length == 51
      assert game2.discard |> length == 1
      assert game3.draw |> length == 50
      assert game3.discard |> length == 2
    end

    test "does nothing when draw pile is empty", %{options: options} do
      game = Game.new("discard2", options)
      game = %{game | draw: [], discard: game.draw}
      game2 = Game.discard(game)
      assert game.draw |> length == 0
      assert game.discard |> length == 52
      assert game2.draw |> length == 0
      assert game2.discard |> length == 52
    end
  end

  describe "move/1" do
    test "First Trick Works", %{options: options} do
      game = Game.new("move1", options)

      card_w = %Card{rank: 7, suit: :h}
      card_n = %Card{rank: 2, suit: :h}
      card_e = %Card{rank: 12, suit: :h}
      card_s = %Card{rank: 9, suit: :h}

      assert {:error, "Inactive player attempted to play a card"} =
               Game.play(game, :south, card_s)

      assert {:ok, game} = Game.play(game, :east, card_e)
      assert {:ok, game} = Game.play(game, :south, card_s)
      assert {:ok, game} = Game.play(game, :west, card_w)
      assert game.trick |> length == 3
      assert {:ok, game} = Game.play(game, :north, card_n)
      assert game.trick |> length == 0
      assert game.turn == :east
      assert game.east.tricks_won == 1
      # game |> IO.inspect(label: "label")
    end
  end

  describe "trick_winner/1" do
    test "Simple case" do
      winner =
        Game.trick_winner([
          {%Card{rank: 7, suit: :h}, :north},
          {%Card{rank: 2, suit: :h}, :west},
          {%Card{rank: 10, suit: :h}, :south},
          {%Card{rank: 9, suit: :h}, :east}
        ])

      assert winner == {%Card{rank: 10, suit: :h}, :south}
    end

    test "Offsuit high card doesn't win" do
      winner =
        Game.trick_winner([
          {%Card{rank: 7, suit: :h}, :north},
          {%Card{rank: 2, suit: :h}, :west},
          {%Card{rank: 12, suit: :c}, :south},
          {%Card{rank: 9, suit: :h}, :east}
        ])

      assert winner == {%Card{rank: 9, suit: :h}, :east}
    end

    test "Low spade wins" do
      winner =
        Game.trick_winner([
          {%Card{rank: 7, suit: :h}, :north},
          {%Card{rank: 2, suit: :s}, :west},
          {%Card{rank: 12, suit: :h}, :south},
          {%Card{rank: 9, suit: :h}, :east}
        ])

      assert winner == {%Card{rank: 2, suit: :s}, :west}
    end

    test "Nothing beats spades" do
      winner =
        Game.trick_winner([
          {%Card{rank: 9, suit: :s}, :north},
          {%Card{rank: 2, suit: :s}, :west},
          {%Card{rank: 12, suit: :c}, :south},
          {%Card{rank: 5, suit: :s}, :east}
        ])

      assert winner == {%Card{rank: 9, suit: :s}, :north}
    end
  end
end

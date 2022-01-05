defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "the world" do
    assert 1 + 1 == 2
  end

  test "create_deck makes 52 cards" do
    deck_length = length(Cards.create_deck)
    assert deck_length == 52
  end

  test "shuffling a deck randomizes it" do
    # Shitty test because there is a chance it will fail but w/e

    deck = Cards.create_deck
    assert deck != Cards.shuffle(deck)
    refute deck == Cards.shuffle(deck)
  end
end

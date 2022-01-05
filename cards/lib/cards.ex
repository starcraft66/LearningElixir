defmodule Cards do
  @moduledoc """
  Provides methods for creating and handling a deck of cards
  """

  @doc """
  Returns a list of strings representing a deck of playing cards
  """
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"]
    suits = ["Hearts", "Clubs", "Diamonds", "Spades"]
    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end
  end

  @doc """
  Takes a deck of playing cards and returns a shuffled deck
  """
  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
  Determines whether a `deck` contains a given `card`.

  ## Examples
      iex> deck = Cards.create_deck
      iex> Cards.contains?(deck, "Ace of Spades")
      true
      iex> Cards.contains?(deck, "of Spades")
      false
  """
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
  Divides a deck into a hand and the reaminder of the deck.
  The `hand_size` argument indicates how many cards should be in the hand.

  ## Examples
      iex(1)> deck = Cards.create_deck
      ["Ace of Hearts", "Two of Hearts", "Three of Hearts",
       "Four of Hearts", "Five of Hearts", "Six of Hearts",
       "Seven of Hearts", "Eight of Hearts", "Nine of Hearts",
       "Ten of Hearts", "Jack of Hearts", "Queen of Hearts",
       "King of Hearts", "Ace of Clubs", "Two of Clubs", "Three of Clubs",
       "Four of Clubs", "Five of Clubs", "Six of Clubs", "Seven of Clubs",
       "Eight of Clubs", "Nine of Clubs", "Ten of Clubs", "Jack of Clubs",
       "Queen of Clubs", "King of Clubs", "Ace of Diamonds",
       "Two of Diamonds", "Three of Diamonds", "Four of Diamonds",
       "Five of Diamonds", "Six of Diamonds", "Seven of Diamonds",
       "Eight of Diamonds", "Nine of Diamonds", "Ten of Diamonds",
       "Jack of Diamonds", "Queen of Diamonds", "King of Diamonds",
       "Ace of Spades", "Two of Spades", "Three of Spades",
       "Four of Spades", "Five of Spades", "Six of Spades",
       "Seven of Spades", "Eight of Spades", "Nine of Spades",
       "Ten of Spades", "Jack of Spades", "Queen of Spades",
       "King of Spades"]
      iex(2)> {_hand, _deck} = Cards.deal(deck, 1)
      {["Ace of Hearts"],
      ["Two of Hearts", "Three of Hearts", "Four of Hearts",
       "Five of Hearts", "Six of Hearts", "Seven of Hearts",
       "Eight of Hearts", "Nine of Hearts", "Ten of Hearts",
       "Jack of Hearts", "Queen of Hearts", "King of Hearts",
       "Ace of Clubs", "Two of Clubs", "Three of Clubs", "Four of Clubs",
       "Five of Clubs", "Six of Clubs", "Seven of Clubs",
       "Eight of Clubs", "Nine of Clubs", "Ten of Clubs", "Jack of Clubs",
       "Queen of Clubs", "King of Clubs", "Ace of Diamonds",
       "Two of Diamonds", "Three of Diamonds", "Four of Diamonds",
       "Five of Diamonds", "Six of Diamonds", "Seven of Diamonds",
       "Eight of Diamonds", "Nine of Diamonds", "Ten of Diamonds",
       "Jack of Diamonds", "Queen of Diamonds", "King of Diamonds",
       "Ace of Spades", "Two of Spades", "Three of Spades",
       "Four of Spades", "Five of Spades", "Six of Spades",
       "Seven of Spades", "Eight of Spades", "Nine of Spades",
       "Ten of Spades", "Jack of Spades", "Queen of Spades",
       "King of Spades"]}
  """
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, reason} -> "The file #{filename} does not exist! Error: #{reason}"
    end
  end

  def create_hand(hand_size) do
    Cards.create_deck
    |> Cards.shuffle
    |> Cards.deal(hand_size)
  end
end

require_relative 'card'

class Deck
  CARD_VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)
  CARD_SUITS = %w(+ <3 ^ <>)

  attr_reader :cards

  def initialize
    @cards = []
    CARD_VALUES.each do |value|
      CARD_SUITS.each do |suit|
        @cards << Card.new(value, suit)
      end
    end
  end

  def shuffle
    @cards.shuffle!
    self
  end

  def give_card
    @cards.pop
  end

end
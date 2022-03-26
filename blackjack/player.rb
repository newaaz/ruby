class Player
  attr_reader :name, :cards, :money

  def initialize(name)
    @money = 0
    @cards = []
    @name = name
  end

  def take_card(deck)
    self.cards << deck.give_card
  end

  def remove_card
    @cards.pop
  end

  def reset_cards
    @cards = []
  end

  def put_to_deposit(money)
    @money += money
  end

  def take_from_deposit(money)
    @money -= money
  end

  # Подсчёт очков у заданных карт
  def card_points
    ace_count = 0
    sum = 0
    cards.each do |card|
      if %w(J Q K).include?(card.value)
        sum +=10
      elsif card.value == 'A'
        if sum < 11 && ace_count.zero?
          sum += 11
          ace_count += 1
        elsif ace_count > 0
          sum = ace_count + 1
        else
          sum += 1
        end
      else
        sum += card.value.to_i
      end      
    end
    sum
  end

end
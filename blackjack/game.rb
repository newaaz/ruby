class Game
  attr_reader :player, :dealer, :deck, :round, :bet

  MENU_TWO_CARDS_OPTIONS = <<-MENU
    Выберите действие:
    <1> Взять ещё карту
    <2> Пропустить ход
    <3> Открыть карты
    <0> Выход из игры
  MENU

  MENU_TWO_CARDS_CHOICE = {
    1 => :player_take_card,
    2 => :player_skip_turn,
    3 => :open_cards,
    0 => :exit
  }.freeze

  MENU_MORE_TWO_CARDS_OPTIONS = <<-MENU
    Выберите действие:
    <1> Пропустить ход
    <2> Открыть карты
    <0> Выход из игры
  MENU

  MENU_MORE_TWO_CARDS_CHOICE = {
    1 => :player_skip_turn,
    2 => :open_cards,
    0 => :exit
  }.freeze

  MENU_AFTER_ROUND_OPTIONS = <<-MENU
    Выберите действие:
    <1> Играть ещё
    <0> Выход из игры
  MENU

  MENU_AFTER_ROUND_CHOICE = {
    1 => :new_round,
    0 => :exit
  }.freeze

  def initialize
    @round = 0
  end

  def start
    puts "Игра \"Black Jack\""    
    puts "Введите своё имя:"
    @player = Player.new(gets.chomp)
    @player.put_to_deposit(100)
    @dealer = Player.new("Diller")
    @dealer.put_to_deposit(100)    
    puts "Добро пожаловать #{player.name}"
    new_round
  end

  def new_round
    puts "Раунд № #{@round += 1}"
    new_deck
    place_bet(10)
    @player.reset_cards
    @dealer.reset_cards
    2.times do 
      @player.take_card(@deck)
      @dealer.take_card(@deck)
    end
    player_choice
  end

  def player_choice
    display_info
    if @player.cards.count == 2
      menu_when_two_cards
    else
      menu_when_more_two_cards
    end
  end  

  def menu_when_two_cards
    puts MENU_TWO_CARDS_OPTIONS
    send MENU_TWO_CARDS_CHOICE[gets.to_i]
  rescue TypeError
    puts "Введите корректный пункт"
  end

  def menu_when_more_two_cards
    puts MENU_MORE_TWO_CARDS_OPTIONS
    send MENU_MORE_TWO_CARDS_CHOICE[gets.to_i]
  rescue TypeError
    puts "Введите корректный пункт"
  end

  def menu_after_round
    puts MENU_AFTER_ROUND_OPTIONS
    send MENU_AFTER_ROUND_CHOICE[gets.to_i]
  rescue TypeError
    puts "Введите корректный пункт"
  end

  def player_take_card    
    card = @player.take_card(@deck).last
    puts "Вы взяли карту #{card.value}#{card.suit}"    
    dealer_choice
  end

  def open_cards
    puts "Открываем карты"    
    scoring_results
  end

  def scoring_results
    display_scoring_info
    analyze_scoring    
    puts "Раунд окончен"
    menu_after_round
  end

  def display_scoring_info
    print "Ваши карты: "
    @player.cards.each { |card| print "Карта #{card.value}#{card.suit} " }
    print " = #{@player.card_points} очков у игрока #{@player.name}\n"
    puts "=============================="
    print "Карты Дилера: "
    @dealer.cards.each { |card| print "Карта #{card.value}#{card.suit} " }
    print " = #{@dealer.card_points} очков у Дилера\n"
  end

  def analyze_scoring
    player_score = @player.card_points
    dealer_score = @dealer.card_points
    if player_score <= 21 && dealer_score <= 21
      if player_score == dealer_score || (player_score > 21 && dealer_score > 21)
        puts "Ничья"
      elsif player_score > dealer_score
        puts "Победил игрок"
        @player.put_to_deposit(@bet)
      else
        puts "Победил Дилер"
        @dealer.put_to_deposit(@bet)
      end
    elsif player_score >= 21
      puts "Победил Дилер"
      @dealer.put_to_deposit(@bet)
    else
      puts "Победил Игрок!"
      @player.put_to_deposit(@bet)
    end
  end

  def display_info
    puts "=============================="
    puts "Ваши карты: "
    @player.cards.each { |card| puts "Карта #{card.value}#{card.suit}" }
    puts "Денег на депозите #{@player.money}"
    puts "=============================="
    puts "Карты Компьютера: "
    @dealer.cards.each { |card| puts "Карта [X]" }
    puts "Денег на депозите #{@dealer.money}"
    puts "=============================="
  end
  
  def player_skip_turn
    puts "Вы пропустили ход"
    dealer_choice
  end

  def dealer_choice
    puts "Дилер думает..."
    sleep(2)
    if @dealer.card_points >= 17
      puts "Дилер пропустил ход, теперь ваша очередь"
      player_choice
    else
      puts "Дилер берёт карту"
      @dealer.take_card(@deck)
    end
    open_cards if @dealer.cards.count == 3 && @player.cards.count == 3
    player_choice
  end

  def new_deck
    @deck = Deck.new.shuffle
  end

  def place_bet(money)
    if @player.money < money
      puts "У вас нет денег на ставку. Выход из игры через 2 секунды..."
      sleep(2)
      exit
    else
      @player.take_from_deposit(money)
      @dealer.take_from_deposit(money)
      @bet = money * 2
    end  
  end
end
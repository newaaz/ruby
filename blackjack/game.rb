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

  def initialize(bet)
    @round = 0
    bet == 0 ? @bet = 10 : @bet = bet
  end

  def start
    puts "Игра \"Black Jack\""  
    puts "Ставка: #{@bet}$"
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
    place_bet(@bet)
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
    check_deposit_after_round
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
      if player_score == dealer_score
        puts "Ничья"
        @player.put_to_deposit(@bet)
        @dealer.put_to_deposit(@bet)
      elsif player_score > dealer_score
        puts "Победил игрок"
        @player.put_to_deposit(@bet * 2)
      else
        puts "Победил Дилер"
        @dealer.put_to_deposit(@bet * 2)
      end
    elsif player_score > 21 && dealer_score > 21
      puts "Ничья"
      @player.put_to_deposit(@bet)
      @dealer.put_to_deposit(@bet)
    elsif player_score >= 21
      puts "Победил Дилер"
      @dealer.put_to_deposit(@bet * 2)
    else
      puts "Победил Игрок!"
      @player.put_to_deposit(@bet * 2)
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

  def check_deposit_after_round
    if @player.money < @bet
      puts "У вас больше нет денег на ставку. Что выберите?"
      menu_restart
    elsif @dealer.money < @bet
      puts "Поздравляем, вы победили!. Что дальше?"
      menu_restart
    end
  end

  def menu_restart
    puts "<1> Рестарт игры"
    puts "<0> Выход из игры"
    case gets.chomp.to_i
          when 1
            restart_game
          when 0
            exit_game
    end
  end

  def restart_game
    puts "Начинаем игру заново"
    @round = 0
    @player.reset_deposit
    @player.put_to_deposit(100)
    @dealer.reset_deposit
    @dealer.put_to_deposit(100)
    new_round
  end

  def exit_game
    puts "В следующий раз непременно повезёт! Выход из игры через 2 секунды..."    
    sleep(2)
    exit
  end

  def place_bet(bet)
    @player.take_from_deposit(bet)
    @dealer.take_from_deposit(bet)
  end
end
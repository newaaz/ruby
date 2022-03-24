# frozen_string_literal: true

class Railway
  attr_reader :stations, :routes, :trains, :wagons

  def initialize
    @stations = []
    @routes = []
    @trains = []
  end

  MAIN_MENU_OPTIONS = <<-LIST
    Главное меню:
    <1> Создать станцию
    <2> Создать поезд
    <3> Создать маршрут / Редактировать маршрут
    <4> Назначить маршут поезду
    <5> Менеджмент вагонов
    <6> Переместить поезд
    <7> Информация о станциях и поездах на них
    <0> Выход из программы
  LIST

  MAIN_MENU_CHOICE = {
    1 => :create_station,
    2 => :create_train,
    3 => :menu_routes,
    4 => :set_route,
    5 => :wagon_management,
    6 => :move_train,
    7 => :stations_info,
    0 => :exit
  }.freeze

  CREATE_TRAIN_OPTIONS = <<-LIST
    Укажите тип поезда:
    <1> Грузовой
    <2> Пассажирский
    <3> Назад в главное меню
    <0> Выход
  LIST

  CREATE_TRAIN_CHOICE = {
    1 => :create_cargo_train,
    2 => :create_passenger_train,
    3 => :main_menu,
    0 => :exit
  }.freeze

  MENU_ROUTES_OPTIONS = <<-LIST
    Выберите действие:
    <1> Создать маршрут
    <2> Редактировать маршрут
    <3> Назад в главное меню
    <0> Выход
  LIST

  MENU_ROUTES_CHOICE = {
    1 => :create_route,
    2 => :edit_route,
    3 => :main_menu,
    0 => :exit
  }.freeze

  MENU_ROUTES_EDIT_OPTIONS = <<-LIST
    Выберите действие:
    <1> Добавить станцию в маршрут
    <2> Удалить станцию из маршрута
    <3> Назад в главное меню
    <0> Выход
  LIST

  MENU_ROUTES_EDIT_CHOICE = {
    1 => :add_station_to_route,
    2 => :remove_station_from_route,
    3 => :main_menu,
    0 => :exit
  }.freeze

  MENU_WAGONS_OPTIONS = <<-LIST
    Выберите действие:
    <1> Добавить вагон
    <2> Удалить вагон
    <3> Заполнить грузом / Продать билет
    <4> Главное меню
    <0> Выход
  LIST

  MENU_WAGONS_CHOICE = {
    1 => :add_wagon,
    2 => :remove_wagon,
    3 => :fill_wagon,
    4 => :main_menu,
    0 => :exit
  }.freeze

  def main_menu
    puts MAIN_MENU_OPTIONS
    send MAIN_MENU_CHOICE[gets.to_i]
  rescue TypeError
    puts "Введите корректный пункт"
  end

  MOVE_TRAIN_OPTIONS = <<-L
    Выберите действие:
    <1> Переместить вперёд
    <2> Переместить назад
    <3> Выход в главное меню
    <0> Выход
  L

  MOVE_TRAIN_CHOICE = {
    1 => :move_next_station,
    2 => :move_prev_station,
    3 => :main_menu,
    0 => :exit
  }.freeze

  private

  def create_station
    print "Введите название станции "
    station = gets.chomp
    @stations << Station.new(station)
    puts "Станция '#{station}' успешно добавлена"
    main_menu
  end

  def create_train
    puts CREATE_TRAIN_OPTIONS
    send CREATE_TRAIN_CHOICE[gets.to_i]
  rescue TypeError
    puts "Введите корректный пункт"
    retry
  end

  def ask_train_number
    puts "Введите номер поезда"
    gets.chomp
  end

  def create_cargo_train
    @trains << train = CargoTrain.new(ask_train_number)
    puts "Грузовой поезд № #{train.number} успешно создан"
  rescue RuntimeError => e
    puts "Error! #{e.message} - Введите правильный номер"
    retry
  end

  def create_passenger_train
    @trains << train = PassengerTrain.new(ask_train_number)
    puts "Пассажирский поезд № #{train.number} успешно создан"
  rescue RuntimeError => e
    puts "Error! #{e.message} - Введите правильный номер"
    retry
  end

  def stations_info
    puts "Выберите станцию:"
    display_stations
    station = @stations[gets.chomp.to_i]
    trains_on_station(station)
  end

  def trains_on_station(station)
    station.each_train { |train| puts "Поезд № #{train.number} | Тип: #{train.type} | Вагонов: #{train.wagons.size}" }
    if station.trains.any?
      puts "Введите название поезда о котором хотите узнать подробнее"
      train = Train.find gets.chomp
      train_info(train)
    else
      puts "На станции нет поездов"
    end
    main_menu
  end

  def train_info(train)
    case train.type
    when :cargo
      train.each_wagon_with_index do |wagon, index|
        puts "Вагон № #{index + 1} | #{wagon.type} | Доступный объём #{wagon.free_area} из #{wagon.area}"
      end
    when :passenger
      train.each_wagon_with_index do |wagon, index|
        puts "Вагон № #{index + 1} | #{wagon.type} | Доступно мест #{wagon.free_area} из #{wagon.area}"
      end
    end
    main_menu
  end

  def menu_routes
    puts MENU_ROUTES_OPTIONS
    send MENU_ROUTES_CHOICE[gets.to_i]
    menu_routes
  rescue TypeError
    puts "Введите корректный пункт"
    retry
  end

  def create_route
    puts "Создать маршрут можно только из существующих станций:"
    display_stations
    print "Введите номер начальной станции: "
    start_station_index = gets.chomp.to_i - 1
    print "Теперь - номер конечной станции: "
    end_station_index = gets.chomp.to_i - 1
    @routes = Route.new @stations[start_station_index], @stations[end_station_index]
    puts "Маршрут создан"
  end

  def display_stations
    @stations.each_with_index { |station, index| puts "<#{index + 1}> #{station.name}" }
  end

  def display_routes
    @routes.each_with_index do |route, index|
      puts "<#{index + 1}> #{route.stations.first.name} - #{route.stations.last.name}"
    end
  end

  def display_route_stations_for_remove(route)
    route.stations.each_with_index { |station, index| print "<#{index + 1}> #{station.name} -> " }
    puts "Введите номер станции которую нужно удалить"
    route.stations[gets.chomp.to_i - 1]
  end

  def edit_route
    puts MENU_ROUTES_EDIT_OPTIONS
    send MENU_ROUTES_EDIT_CHOICE[gets.to_i]
  end

  def add_station_to_route
    puts "Выберите маршрут для добавления станции"
    route = display_routes[gets.chomp.to_i - 1]
    puts "Введите номер станции которую нужно добавить"
    display_stations
    route.add_station @stations[gets.chomp.to_i - 1]
    puts "Станция добавлена"
  end

  def remove_station_from_route
    puts "Выберите маршрут для удаления станции"
    route = display_routes[gets.chomp.to_i - 1]
    route.delete_station display_route_stations_for_remove(route)
    puts "Станция удалена"
  end

  def set_route
    puts "Укажите номер поезда которому назначаем маршрут"
    train = select_train_from_list
    puts "Укажите номер маршрута который нужно назначить выбранному поезду"
    display_routes
    route = @routes[gets.chomp.to_i - 1]
    train.take_route route
    puts "Маршрут назначен"
    main_menu
  end

  def wagon_management
    puts MENU_WAGONS_OPTIONS
    send MENU_WAGONS_CHOICE[gets.to_i]
  rescue TypeError
    puts "Введите корректный пункт"
    retry
  end

  def add_wagon
    train = select_train_from_list
    case train.type
    when :cargo
      add_cargo_wagon_for_train(train)
    when :passenger
      add_passenger_wagon_for_train(train)
    end
    main_menu
  end

  def add_cargo_wagon_for_train(train)
    puts "Введите грузовой объём этого вагона в куб.м."
    area = gets.to_i
    train.add_wagon CargoWagon.new area
    puts "Грузовой вагон добавлен"
  end

  def add_passenger_wagon_for_train(train)
    puts "Введите количество мест в этом вагоне"
    area = gets.to_i
    train.add_wagon PassengerWagon.new area
    puts "Пассажирский вагон добавлен"
  end

  def remove_wagon
    train = select_train_from_list
    train.remove_wagon
    puts "Вагон удалён"
    main_menu
  end

  def fill_wagon
    train = select_train_from_list
    wagon = select_wagon_from_train(train)
    case wagon.type
    when :cargo
      fill_cargo_wagon
    when :passenger
      wagon.fill_area if wagon.free_area >= 1
    end
    puts "Вагон дополнен"
    main_menu
  end

  def fill_cargo_wagon(wagon)
    puts "Введите количество добавляемого объёма груза"
    added_area = gets.chomp.to_i
    wagon.fill_area(added_area) if wagon.free_area > added_area
  end

  def select_wagon_from_train(train)
    puts "Выберите вагон"
    train.wagons.each_with_index { |_wagon, index| puts "Вагон № <#{index + 1}>" }
    train.wagons[gets.chomp.to_i - 1]
  end

  def select_train_from_list
    puts "Выберите поезд"
    @trains.each_with_index { |train, index| puts "<#{index + 1}> #{train.number}" }
    @trains[gets.chomp.to_i - 1]
  end

  def move_train
    puts MOVE_TRAIN_OPTIONS
    send MOVE_TRAIN_CHOICE[gets.to_i]
    main_menu
  rescue TypeError
    puts "Введите корректный пункт"
    retry
  end

  def move_next_station
    train = select_train_from_list
    train.move_next_station
  end

  def move_prev_station
    train = select_train_from_list
    train.move_prev_station
  end

  public

  # заполняем тестовыми данными
  # Публичный, потому что вызывается извне
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def seed
    @stations << Station.new("Feodosia")
    @stations << Station.new("Belgorod")
    @stations << Station.new("Moscow")
    @stations << Station.new("SPB")
    @stations << Station.new("Kursk")
    @stations << Station.new("Ivanovo")
    @trains << CargoTrain.new("Feoel")
    @trains << CargoTrain.new("Ivnel")
    @trains << PassengerTrain.new("FeoMs")
    @trains << PassengerTrain.new("KrsSB")
    @routes << Route.new(@stations[0], @stations[2])
    @routes << Route.new(@stations[1], @stations[5])
    @routes << Route.new(@stations[2], @stations[3])
    @trains.each { |train| train.take_route @routes[rand(0..2)] }
    15.times do
      Train.find("Feoel").add_wagon CargoWagon.new rand(1000)
      Train.find("Ivnel").add_wagon CargoWagon.new rand(1000)
      Train.find("FeoMs").add_wagon PassengerWagon.new rand(56)
      Train.find("KrsSB").add_wagon PassengerWagon.new rand(56)
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end

class Railway
  attr_reader :stations, :routes, :trains, :wagons

  def initialize
    @stations = []
    @routes = []
    @trains = []
  end

  # main menu
  def menu_railway
    loop do
      puts "Главное меню                                                \n
            Выберите действие:                                          \n
            <1> Создать станцию                                         \n
            <2> Создать поезд                                           \n
            <3> Создать маршрут                                         \n
            <4> Редактировать маршрут                                   \n
            <5> Назначить маршут поезду                                 \n
            <6> Менеджмент вагонов                                      \n
            <7> Переместить поезд                                       \n
            <9> Просмотреть список всех станций, и поездов на них       \n
            <0> Выход из программы                                      \n"  
      choice = gets.chomp.to_i        
      case choice
      when 1
        create_station
      when 2
        create_train
      when 3
        create_route
      when 4
        routes_edit
      when 5
        set_route
      when 6
        wagon_management
      when 7
        move_train
      when 9
        display_stations
      when 0
        puts "Выход успешно осуществлён"
        break
      end         
    end
  end

  private   # Помещаем все методы кроме вызова меню в Private, чтобы они могли вызываться только из меню
  
  # создаём станцию
  def create_station
    print "Введите название станции "
    station = gets.chomp    
    @stations << Station.new(station)
    puts "Станция '#{station}' успешно добавлена"
  end

  # Выводим список станций
  def display_stations
    @stations.each do |station|
      puts "---  Станция \"#{station.name}\"  ---"
      station.each_train { |train| puts "Поезд № #{train.number} | Тип: #{train.type} | Вагонов: #{train.wagons.size}" }
    end
    puts "Введите название поезда о котором хотите узнать подробнее"    
    train = Train.find gets.chomp
    if train.type == :cargo
      train.each_wagon_with_index { |wagon, index| puts "Вагон № #{index + 1} | #{wagon.type} | Доступный объём #{wagon.free_volume} из #{wagon.volume}" }
    elsif train.type == :passenger
      train.each_wagon_with_index { |wagon, index| puts "Вагон № #{index + 1} | #{wagon.type} | Доступно мест #{wagon.free_places} из #{wagon.places}" }
    end
  end

  # Создаём поезд
  def create_train
    puts "Введите номер поезда"
    number = gets.chomp
    puts "Укажите тип поезда:           \n
          <1> Грузовой                  \n
          <2> Пассажирский              \n
          <0> Назад в главное меню      \n"
    choice = gets.chomp.to_i        
    case choice
    when 1
      @trains << CargoTrain.new(number)
    when 2
      @trains << PassengerTrain.new(number)
    when 0
      menu_railway
    end
    report_of_create(number)
    rescue RuntimeError => e
      puts "Error! #{e.message} - начните заново"
      retry
  end

  # отчёт об успешном создании поезда
  def report_of_create(number)
    train = Train.find(number)
    puts "Поезд №-#{train.number} успешно создан"
  end

  # создаём маршруты
  def create_route    
    puts "Создать маршрут можно только из существующих станций:"
    @stations.each_with_index { |station, index| puts "   <#{index + 1}> #{station.name}" }
    print "Введите номер начальной станции: "
    start_station_index = gets.chomp.to_i - 1
    print "Теперь - номер конечной станции: "
    end_station_index = gets.chomp.to_i - 1
    route = Route.new @stations[start_station_index], @stations[end_station_index]
    @routes << route
    puts "Маршрут создан."
    menu_route(route)
    
  end

  # Меню для маршрута
  def menu_route(route)
    puts "Выберите действие:
          <1> Добавить в этот маршрут станцию                     \n
          <2> Создать новый маршрут                               \n
          <3> Просмотреть весь список маршрутов для действий      \n
          <0> Выход в главное меню                                \n"
    choice = gets.chomp.to_i        
    case choice
    when 1
      add_station_to_current_route(route)
    when 2
      create_route
    when 3
      routes_edit
    when 0
      menu_railway
    end
  end

  # добавляем/удаляем станции из выбранного маршрута
  def routes_edit
    @routes.each_with_index { |route, index| puts "   <#{index + 1}> #{route.stations.first.name} -  #{route.stations.last.name}" }
    puts "Укажите номер маршрута который хотите редактировать"
    route = @routes[gets.chomp.to_i - 1]
    puts "Выберите действие:
    <1> Добавить в этот маршрут станцию                     \n
    <2> Удалить станцию из маршрута                         \n
    <3> Просмотреть весь список маршрутов для действий      \n
    <0> Выход в главное меню                                \n"
    choice = gets.chomp.to_i
    case choice
    when 1
      # добавляем в текущий маршрут ещё одну станцию
      add_station_to_current_route(route)
    when 2
      remove_station(route)
    when 3
      # выводим все маршруты для действий над ними
      routes_edit
    when 0
      menu_railway
    end
  end

  # удаляем станцию из маршрута
  def remove_station(route)
    puts "Станции в маршруте"
    route.stations.each_with_index { |station, index| print "<#{index + 1}> #{station.name} -> " }
    puts "Введите номер станции (из указанных выше) которую нужно удалить"
    route.delete_station @stations[gets.chomp.to_i - 1]
    menu_route(route)
  end

  # добавляем станцию из списка в текущий маршрут
  def add_station_to_current_route(route)
    @stations.each_with_index { |station, index| puts "   <#{index + 1}> #{station.name}" }
    puts "Введите номер станции (из указанных выше) которую нужно добавить"
    route.add_station @stations[gets.chomp.to_i - 1]
    puts "Станция добавлена"
    menu_route(route)
  end

  # Назначаем маршрут поезду
  def set_route
    puts "Укажите номер поезда которому назначаем маршрут"
    train = select_train_from_list
    puts "Укажите номер маршрута который нужно назначить выбранному поезду"
    @routes.each_with_index { |route, index| puts "   <#{index + 1}> #{route.stations.first.name} -  #{route.stations.last.name}" }
    route = @routes[gets.chomp.to_i - 1]
    train.take_route route
  end

  # Менеджмент вагонов
  def wagon_management
    puts "Укажите номер поезда которому требуется добавить/удалить вагон продать билет или заполнить грузом"
    train = select_train_from_list
    if train.type == :cargo
      puts "Выберите действие для грузового поезда:                     \n
            <1> Добавить вагон к поезду                                 \n
            <2> Удалить вагон                                           \n
            <3> Наполнить грузом                                        \n
            <4> Вернуться к выводу поездов для управления вагонами      \n
            <0> Выход в главное меню                                    \n"
      choice = gets.chomp.to_i
      case choice
      when 1      
        add_cargo_wagon_for(train)      
      when 2
        train.remove_wagon
      when 3
        fill_cargo_wagon(train)
      when 4
        wagon_management
      when 0
        menu_railway
      end
    elsif train.type == :passenger
      puts "Выберите действие для пассажирского поезда:                 \n
            <1> Добавить вагон к поезду                                 \n
            <2> Удалить вагон                                           \n
            <3> Продать билет                                           \n
            <4> Вернуться к выводу поездов для управления вагонами      \n
            <0> Выход в главное меню                                    \n"
      choice = gets.chomp.to_i
      case choice
      when 1      
        add_passenger_wagon_for(train)     
      when 2
        train.remove_wagon
      when 3
        fill_passenger_wagon(train)
      when 4
        wagon_management
      when 0
        menu_railway
      end
    end
  end

  def fill_passenger_wagon(train)    
    train.each_wagon_with_index { |wagon, index| puts "Вагон № #{index + 1} | #{wagon.type} | Доступно мест #{wagon.free_places} из #{wagon.places}" }
    puts "Выберите № вагона для продажи билета"
    wagon = train.wagons[gets.chomp.to_i - 1]
    wagon.sell_ticket if wagon.free_places > 0
  end

  def fill_cargo_wagon(train)
    train.each_wagon_with_index { |wagon, index| puts "Вагон № #{index + 1} | Доступный объём #{wagon.free_volume} из #{wagon.volume}" }
    puts "Выберите № вагона для заполнения груза"
    wagon = train.wagons[gets.chomp.to_i - 1]
    puts "Введите количество добавляемого объёма груза"
    added_volume = gets.chomp.to_i
    wagon.fill_volume(added_volume) if wagon.free_volume > added_volume 
  end

  def add_cargo_wagon_for(train)
    puts "Введите грузовой объём этого вагона в куб.м."
    volume = gets.to_i
    wagon = CargoWagon.new volume
    train.add_wagon wagon
  end

  def add_passenger_wagon_for(train)
    puts "Введите количество мест в этом вагоне"
    places = gets.to_i
    wagon = PassengerWagon.new places
    train.add_wagon wagon
  end

  # Перемещение поезда
  def move_train
    puts "Укажите номер поезда которому требуется переместить"
    train = select_train_from_list
    puts "Выберите действие:
    <1> Переместить вперёд                              \n
    <2> Переместить назад                               \n
    <3> Вернуться к выводу поездов для перемещения      \n
    <0> Выход в главное меню                            \n"
    choice = gets.chomp.to_i
    case choice
    when 1
      train.move_next_station
    when 2
      train.move_prev_station
    when 3
      move_train
    when 0
      menu_railway
    end
  end

  def select_train_from_list
    @trains.each_with_index { |train, index| puts "<#{index + 1}> #{train.number}" }
    train = @trains[gets.chomp.to_i - 1]
  end

  public

  # заполняем тестовыми данными
  # Публичный, потому что вызывается извне
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
end



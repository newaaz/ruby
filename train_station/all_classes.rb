class Station
  attr_reader :trains, :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    unless @trains.include?(train)
      @trains << train
      puts "#{train.title} прибыл на станцию #{name}"    
    else
      puts "Этот поезд уже на станции"
    end
  end

  def send_train(train)
    # проверить на наличие поезда на станции
    if @trains.include?(train)
      @trains.delete(train)
      puts "#{train.name} отбыл со станции #{name}"
    else
      puts "Такого поезда на станции нет: #{train}"
    end
  end

  # Выводим кол-во находящихся поездов по типу
  def display_trains_by_type
    passenger_train = trains.select { |train| train.type == "pass" }
    cargo_train = trains.select { |train| train.type == "cargo" }
    puts "На станции находятся:"
    puts "--- Пассажирские поезда ---"
    passenger_train.each { |train| puts train.title }
    puts "--- Грузовые поезда ---"
    cargo_train.each { |train| puts train.title }
  end
end

class Route
  attr_reader :stations
  
  def initialize(start_station, end_station)
    @points = [start_station, end_station]  
  end

  # добавляем станцию. не должна дублироваться
  def add_station(station)
    unless (@stations.include?(station))
      @stations.insert 1, station    
    else
      puts "Cтанция #{station.name} уже есть в списке"
    end
  end

  # удаляем станцию. Проверить есть ли она в маршруте
  # не должна быть начальной или конечной
  def delete_station(station)
    if stations.include?(station) && stations.first != station && stations.last != station
      stations.delete(station)
    else
      puts "Такой станции нет в маршруте, или она является начальной или конечной"
    end
  end

  # Выводим названия станций
  def display_stations_names
    stations.each { |station| puts station.name }
  end
end

class Train
  attr_accessor :speed, :route, :current_station_index
  attr_reader   :wagons, :type, :title

  def initialize(title, type, wagons)
    @title = title
    @type = type
    @wagons = wagons.to_i
    @speed = 0    
  end

  def speed_up(value)
    @speed += value
  end

  def stop
    @speed = 0
  end

  # принимаем маршрут
  def take_route(route)
    @route = route
    # помещаем на первую станцию в маршруте
    route.stations.first.add_train(self)
    @current_station_index = 0
  end

  # добавляем вагоны
  def add_wagon
    @wagons += 1 if @speed == 0
  end
  # отцепляем вагоны
  def remove_wagon
    if @wagons >= 1
      @wagons -= 1 if @speed == 0
    else
      puts "Состав уже пустой"
    end
  end

  def current_station
    route.stations[@current_station_index]
  end

  def next_station
    unless @current_station == self.route.stations.last
      # В этом методе, не двигаем поезд, а просто возвращаем следующую станцию
      # поэтому @current_station_index не меняем, он изменится в .move_next_station
      self.route.stations[@current_station_index + 1]
    else
      puts "Вы находитесь в конечной точке маршрута"
    end    
  end

  def prev_station
    # Здесь также как и в .next_station, только возвращается предыдущая станция
    # без изменения индекса @current_station_index
    unless @current_station == self.route.stations.first
      self.route.stations[@current_station_index - 1]
    else
      puts "Вы находитесь в начальной точке маршрута"
    end
  end

  # перемещаем поезд на станцию вперёд
  def move_next_station
    if next_station
      next_station.add_train(self)
      @current_station_index += 1
    end
  end

  # перемещаем поезд на станцию вперёд
  def move_prev_station
    if prev_station
      prev_station.add_train(self)
      @current_station_index -= 1
    end
  end
end
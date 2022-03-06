class Station

  attr_reader :trains, :name

  def initialize(name)
    @name = name.to_s
    @trains = []
  end

  def add_train(train)
    unless @trains.include?(train)
      @trains << train
      puts "#{train.title} прибыл на станцию #{name}"
      # назначаем поезду текущую станцию
      train.current_station = self
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

  # выводим все экземпляры класса Station
  def self.all
    ObjectSpace.each_object(self).to_a
  end

end

class Route
  attr_reader :points
  
  def initialize(start_point, end_point)
    # Если таких станций нет - можно выводить ошибку, но пока не знаю как
    @points = []
    @points.unshift start_point
    @points.push end_point
  end

  # добавляем станцию. Проверить есть ли такая станция в природе
  # не должна дублироваться
  def add_station(station)
    if Station.all.include?(station) && !(@points.include?(station))
      end_point = self.points.last
      points[-1] = station
      points << end_point
    else
      puts "Такой станции не существует, или она уже есть в списке"
    end
  end

  # удаляем станцию. Проверить есть ли она в маршруте
  # не должна быть начальной или конечной
  def delete_station(station)
    if points.include?(station) && points[0] != station && points[-1] != station
      points.delete(station)
    else
      puts "Такой станции нет в маршруте, или она является начальной или конечной"
    end
  end

  # Выводим названия станций
  def display_stations_names
    points.each { |point| puts point.name }
  end
end

class Train

  attr_accessor :speed, :route, :current_station
  attr_reader   :wagons, :type, :title

  def initialize(title, type, wagons)
    @title = title.to_s
    @type = type.to_s
    @wagons = wagons.to_i
    @speed = 0    
  end

  def speed_up(speed_up)
    @speed += speed_up
  end

  def stop
    @speed = 0
  end

  # принимаем маршрут
  def take_route(route)
    @route = route
    # помещаем на первую станцию в маршруте
    route.points[0].add_train(self)
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

  def next_station
    unless @current_station == self.route.points.last
      next_station_index = self.route.points.index(@current_station) + 1
      self.route.points[next_station_index]
    else
      puts "Вы находитесь в конечной точке маршрута"
    end    
  end

  def prev_station
    unless @current_station == self.route.points.first
      prev_station_index = self.route.points.index(@current_station) - 1
      self.route.points[prev_station_index]
    else
      puts "Вы находитесь в начальной точке маршрута"
    end
  end

  # перемещаем поезд на станцию вперёд
  def move_next_station
    next_station.add_train(self) if next_station
  end

  # перемещаем поезд на станцию вперёд
  def move_prev_station
    prev_station.add_train(self) if prev_station
  end

end
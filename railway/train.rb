class Train
  include Manufacturer
  include InstanceCounter
  attr_reader   :title, :type, :wagons, :speed, :route, :current_station_index

  @@all_trains = {}

  class << self
    def find(title)
      @@all_trains[title]
    end
  end

  def initialize(title)
    @title = title
    @wagons = []
    @speed = 0
    @@all_trains[title] = self
    register_instance
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
    route.stations.first.add_train(self)
    @current_station_index = 0
  end

  # добавление вагонов
  def add_wagon(wagon)
    if type == wagon.type
      attach_wagon_by_type(wagon)
    else
      puts "Тип вагона не соответствует типу поезда"
    end
  end

  # добавляем вагон в зависимости от типа поезда
  def attach_wagon_by_type(wagon)
    if type == :cargo
      @wagons << wagon
    elsif type == :passenger
      @wagons << wagon
    else
      puts "Некорректный тип вагона"
    end
  end

  # отцепляем вагоны
  def remove_wagon
    if @wagons.any?
      @wagons.each_with_index { |wagon, index| "Вагон № #{index - 1}" }
      puts "Введите номер удаляемого вагона"
      @wagons.delete @wagon[gets.chomp.to_i - 1] if @speed == 0
    else
      puts "Состав уже пустой"
    end
  end  

  def next_station
    unless @current_station == self.route.stations.last      
      self.route.stations[@current_station_index + 1]
    else
      puts "Вы находитесь в конечной точке маршрута"
    end    
  end

  def prev_station    
    unless @current_station == self.route.stations.first
      self.route.stations[@current_station_index - 1]
    else
      puts "Вы находитесь в начальной точке маршрута"
    end
  end

  # перемещаем поезд на станцию вперёд
  def move_next_station
    if next_station
      route.stations[@current_station_index].send_train
      next_station.add_train(self)
      @current_station_index += 1
    else
      puts "Вы находитесь в конечной точке маршрута"
    end
  end

  # перемещаем поезд на станцию вперёд
  def move_prev_station
    if prev_station
      route.stations[@current_station_index].send_train
      prev_station.add_train(self)
      @current_station_index -= 1
    else
      puts "Вы находитесь в начальной точке маршрута"
    end
  end

  def current_station
    route.stations[@current_station_index]
  end

  private   # Помещаем сеттер :speed, :current_station_index в private, чтобы их можно было менять только внутри класса
  attr_writer :speed, :current_station_index
end
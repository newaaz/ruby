class Station
  include InstanceCounter
  attr_reader :trains, :name

  @@all_stations = []

  class << self
    def all
      @@all_stations
    end
  end

  def initialize(name)
    @name = name
    @trains = []
    @@all_stations << self
    register_instance
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
    passenger_train = trains.select { |train| train.type == :passenger }
    cargo_train = trains.select { |train| train.type == :cargo }
    puts "На станции находятся:"
    puts "--- Пассажирские поезда ---"
    passenger_train.each { |train| puts train.title }
    puts "--- Грузовые поезда ---"
    cargo_train.each { |train| puts train.title }
  end
end

class Station
  include InstanceCounter
  include Validation
  attr_reader :trains, :name

  validate :name, :presence
  validate :name, :length, 5

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
    end
  end

  def send_train(train)
    if @trains.include?(train)
      @trains.delete(train)  
    end
  end

  def show_trains_on_station_by_type(by_type)
    @trains.select { |train| train.type == by_type }
  end
end

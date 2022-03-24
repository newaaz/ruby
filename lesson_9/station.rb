# frozen_string_literal: true

class Station
  include InstanceCounter
  include Validation

  attr_reader :trains, :name

  validate :name, :presence
  validate :name, :length, 3

  @@all_stations = []

  class << self
    def all
      @@all_stations
    end
  end

  def initialize(name)
    @name = name
    validate!
    @trains = []
    @@all_stations << self
    register_instance
  end

  def each_train(&block)
    @trains.each(&block)
  end

  def each_train_with_index(&block)
    @trains.each_with_index(&block)
  end

  def add_train(train)
    @trains << train unless @trains.include?(train)
  end

  def send_train(train)
    @trains.delete(train) if @trains.include?(train)
  end

  def show_trains_on_station_by_type(by_type)
    @trains.select { |train| train.type == by_type }
  end
end

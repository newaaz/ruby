# frozen_string_literal: true

require_relative './modules/manufacturer'
require_relative './modules/instance_counter'
require_relative './modules/validation'
require_relative './modules/accessors'

class Train
  include Manufacturer
  include InstanceCounter
  include Validation
  extend Accessors
  attr_reader :number, :type, :wagons, :speed, :route, :current_station_index

  attr_accessor_with_history :tickets, :passengers
  strong_attr_accessor :country, String
  strong_attr_accessor :wheels, Integer


  NUMBER_FORMAT = /^[a-z\d]{3}-?[a-z\d]{2}$/i.freeze

  validate :number, :presence
  validate :number, :length, 5
  validate :number, :format, NUMBER_FORMAT
  validate :number, :type, String

  @@all_trains = {}

  class << self
    def find(number)
      @@all_trains[number]
    end
  end

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
    @@all_trains[number] = self
    register_instance
    validate!
  end

  def each_wagon(&block)
    @wagons.each(&block)
  end

  def each_wagon_with_index(&block)
    @wagons.each_with_index(&block)
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
    attach_wagon_by_type(wagon) if type == wagon.type
  end

  # добавляем вагон в зависимости от типа поезда
  def attach_wagon_by_type(wagon)
    case type
    when :cargo
      @wagons << wagon
    when :passenger
      @wagons << wagon
    end
  end

  # отцепляем вагоны
  def remove_wagon
    return unless @wagons.any?

    @wagons.each_with_index { |wagon, index| puts "Вагон № #{index + 1} #{wagon.type}" }
    puts "Введите номер удаляемого вагона"
    @wagons.delete @wagons[gets.chomp.to_i - 1] if @speed.zero?
  end

  def next_station
    route.stations[@current_station_index + 1] unless @current_station == route.stations.last
  end

  def prev_station
    route.stations[@current_station_index - 1] unless @current_station == route.stations.first
  end

  # перемещаем поезд на станцию вперёд
  def move_next_station
    return unless next_station

    route.stations[@current_station_index].send_train(self)
    next_station.add_train(self)
    @current_station_index += 1
  end

  # перемещаем поезд на станцию вперёд
  def move_prev_station
    return unless prev_station

    route.stations[@current_station_index].send_train(self)
    prev_station.add_train(self)
    @current_station_index -= 1
  end

  def current_station
    route.stations[@current_station_index]
  end

  private   # Помещаем сеттер :speed, :current_station_index в private, чтобы их можно было менять только внутри класса

  attr_writer :speed, :current_station_index
end

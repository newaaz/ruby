class Route
  include InstanceCounter
  include Validation
  attr_reader :stations

  validate :start_station, :presence
  validate :end_station, :presence
  
  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
    register_instance
  end

  def add_station(station)
    unless (@stations.include?(station))
      @stations.insert -2, station    
    end
  end

  def delete_station(station)
    if stations.include?(station) && stations.first != station && stations.last != station
      stations.delete(station)
    end
  end
end
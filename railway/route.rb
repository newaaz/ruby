class Route
  attr_reader :stations
  
  def initialize(start_station, end_station)
    @stations = [start_station, end_station]  
  end

  # добавляем станцию. не должна дублироваться
  def add_station(station)
    unless (@stations.include?(station))
      @stations.insert -2, station    
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
end
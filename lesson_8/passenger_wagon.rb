class PassengerWagon < Wagon
  attr_reader :type, :places, :tickets
  def initialize(places)
    @type = :passenger
    @places = places
    @tickets = []
  end

  # занимаем места в вагоне (по сути - покупаем билет?) 
  def sell_ticket
    @tickets << { ticket_id: rand(1000) }
  end

  def occupied_places
    @tickets.size
  end

  def free_places
    places - occupied_places
  end

  protected
  attr_writer :places, :tickets
end
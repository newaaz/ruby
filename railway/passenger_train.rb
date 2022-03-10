class PassengerTrain < Train
  def initialize(title)
    super
    @type = :passenger
  end

  def add_wagon
    @wagons << PassengerWagon.new
  end
end
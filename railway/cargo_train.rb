class CargoTrain < Train
  def initialize(title)
    super
    @type = :cargo
  end  

  def add_wagon
    @wagons << CargoWagon.new
  end
end
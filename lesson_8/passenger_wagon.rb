class PassengerWagon < Wagon
  def initialize(area)
    super
    @type = :passenger
  end

  def fill_area
    @filled_area += 1 if free_area >= 1
  end
end
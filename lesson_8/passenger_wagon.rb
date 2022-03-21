class PassengerWagon < Wagon
  def initialize(area)
    super
    @type = :passenger
  end
end
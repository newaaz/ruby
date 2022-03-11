class PassengerTrain < Train
  def initialize(title)
    super
    @type = :passenger
  end
end
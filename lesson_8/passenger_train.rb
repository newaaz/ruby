class PassengerTrain < Train
  attr_reader :type
  validate :number, :presence
  validate :number, :length, 5
  validate :number, :format, NUMBER_FORMAT
  
  def initialize(number)
    super
    @type = :passenger
  end
end
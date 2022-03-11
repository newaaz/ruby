class CargoTrain < Train
  def initialize(title)
    super
    @type = :cargo
  end  
end
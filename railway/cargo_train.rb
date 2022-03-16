class CargoTrain < Train
  puts "something"
  def initialize(title)
    super
    @type = :cargo
  end  
end
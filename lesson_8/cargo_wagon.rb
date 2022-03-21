class CargoWagon < Wagon
  def initialize(area)
    super
    @type = :cargo
  end
end
# frozen_string_literal: true

class CargoWagon < Wagon
  def initialize(area)
    super
    @type = :cargo
  end
end

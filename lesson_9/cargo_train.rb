# frozen_string_literal: true

class CargoTrain < Train
  attr_reader :type

  validate :number, :presence
  validate :number, :length, 5
  validate :number, :format, NUMBER_FORMAT

  def initialize(number)
    super
    @type = :cargo
  end
end

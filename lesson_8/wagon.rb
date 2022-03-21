class Wagon
  include Manufacturer
  attr_reader :type, :area, :filled_area

  def initialize(area)
    @area = area
    @filled_area = 0
  end

  def fill_area(value)
    @filled_area += value if free_area > 0
  end

  def free_area
    area - filled_area
  end
end
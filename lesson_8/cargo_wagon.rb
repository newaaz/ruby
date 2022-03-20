class CargoWagon < Wagon
  attr_reader :type, :volume, :filled_volume
  def initialize(volume)
    @type = :cargo
    @volume = volume
    @filled_volume = 0
  end

  def fill_volume(value)
    self.filled_volume += value
  end

  def occupied_volume
    @filled_volume
  end

  def free_volume
    volume - filled_volume
  end

  protected
  attr_writer :volume, :filled_volume
end
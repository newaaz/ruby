require_relative './modules/validation'
require_relative './modules/accessors'

class Train
  include Validation
  extend Accessors

  attr_accessor_with_history :tickets, :passengers
  strong_attr_accessor :country, String
  strong_attr_accessor :wheels, Integer

  NUMBER_FORMAT = /^[a-z\d]{3}-?[a-z\d]{2}$/i.freeze

  validate :number, :presence
  validate :number, :length, 5
  validate :number, :format, NUMBER_FORMAT
  validate :number, :type, String

  def initialize(number)
    @number = number  
    validate!
  end
end

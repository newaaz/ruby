require_relative './modules/manufacturer'
require_relative './modules/instance_counter'
require_relative './modules/validation'
require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'
require_relative 'railway'

railway = Railway.new
railway.seed
railway.menu_railway








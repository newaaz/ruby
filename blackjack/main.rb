require_relative 'deck'
require_relative 'player'
require_relative 'game'

puts "Введите ставку (по умолчанию - 10$)"
bet = gets.chomp.to_i

game = Game.new(bet)
game.start















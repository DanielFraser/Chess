require_relative 'Pieces/king'
require_relative 'Pieces/queen'

puts "hello"

k = King.new([0, 0], "w")
print k.possible_moves
print k.can_move(1, 1)


require 'colorize'

print "I am now red".red, " "
puts "I am now blue".blue
puts "Testing".yellow
puts k.to_string
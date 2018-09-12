require_relative 'chess_piece'

class King < ChessPiece
  def initialize(loc, color)
    super(loc, color)
  end

  def possible_moves
    moves = []
    (-1..1).each {|x|
      (-1..1).each {|y|
        if (x != 0) or (y != 0)
          puts "#{x}, #{y}"
          if inbounds(x + loc[0], y + loc[1])
            moves.append([x + loc[0], y + loc[1]])
          end
        end
      }
    }
    moves
  end

  def can_move(row, col)
    possible_moves.include?([row, col])
  end

  def to_string
    require 'colorize'
    if color == "w"
      puts "K".white
    else
      puts "K".black
    end
  end
end


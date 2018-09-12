require_relative 'chess_piece'

class Rook < ChessPiece
  def initialize(loc, color)
    super(loc, color)
  end

  def possible_moves
    moves = []
    (-loc[0]..7 - loc[0]).each {|x|
      (-loc[1]..7 - loc[1]).each {|y|
        if (x != 0) or (y != 0)
          if (x == loc[0] && y != loc[1]) || (x != loc[0] && y == loc[1])
            if inbounds(x + loc[0], y + loc[1])
              moves.append([x + loc[0], y + loc[1]])
            end
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
      puts "R".white
    else
      puts "R".black
    end
  end
end

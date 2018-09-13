require_relative 'chess_piece'

class Queen < ChessPiece

  include Diagonal
  include Straight

  def initialize(loc, color)
    super(loc, color)
  end

  def possible_moves
    moves = []
    (-7..7).each {|x|
      (-7..7).each {|y|
        if x + y != 0
          if (is_diagonal([x, y], loc) || is_straight([x, y], loc)) && inbounds(x + loc[0], y + loc[1])
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
    "Q"
  end
end

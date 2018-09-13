require_relative '' 'chess_piece'

class Pawn < ChessPiece
  def initialize(loc, color)
    super(loc, color)
    @first = true
  end

  def possible_moves
    moves = []
    (1..2).each {|x|
      if inbounds(x + loc[0], loc[1])
        moves.append([x + loc[0], loc[1]])
      end
    }
    moves
  end

  def can_move(row, col)
    if @first
      possible_moves.include?([row, col])
    else
      row == loc[0] + 1 && col == loc[1]
    end
  end

  def to_string
    "P"
  end
end

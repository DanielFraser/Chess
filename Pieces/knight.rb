require_relative 'chess_piece'

class Knight < ChessPiece
  def initialize(loc, color)
    super(loc, color)
  end

  def possible_moves
    moves = []
    [[2, 1], [1, 2], [1, -2], [2, -1], [-2, 1], [-1, 2], [-2, -1], [-1, -2]].each {|x|
      if inbounds(x[0] + loc[0], x[1] + loc[1])
        moves.append([x[0] + loc[0], x[1] + loc[1]])
      end
    }
    moves
  end

  def can_move(row, col)
    possible_moves.include?([row, col])
  end

  def to_string
    "k"
  end
end


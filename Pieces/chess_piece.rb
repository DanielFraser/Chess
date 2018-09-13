module Diagonal
  def is_diagonal(pos1, pos2)
     (pos1[0] - pos2[0] == pos1[1] - pos2[1]) || (pos1[0] - pos2[0] == -(pos1[1] - pos2[1]))
  end
end

module Straight
  def is_straight(pos1, pos2)
    (pos1[0] == pos2[0] && pos1[1] != pos2[1]) || (pos1[0] != pos2[0] && pos1[1] == pos2[1])
  end
end

class ChessPiece
  def initialize(loc, color)
    # Instance variables
    @loc = loc
    @color = color
    @cap = false
  end

  def inbounds(row, col)
    return true if (row.between?(0, 7) and col.between?(0, 7))
    false
  end

  def possible_moves

  end

  def can_move

  end

  def to_string

  end

  def captured
    @cap = true
  end

  attr_accessor :loc, :color, :cap
end
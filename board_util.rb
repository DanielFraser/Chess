class Board_util

  def initialize
    @@row = {}
    @@col = {}
  end

  def self.init_hash
    i = 0
    %w[a b c d e f g h].each {|x|
      col[x] = i
      i += 1
    }

    (0..7).each {|i|
      row[8 - i] = i
    }

    puts row, col
  end

  def self.getloc(coordinate)
    [row[coordinate[0]], col[coordinate[1]]]
  end

  def self.convert_coord(pos)
    "abcdefgh"[pos[1]] + 8-pos[0]
  end

  def self.initialize_board
    pieces = []
    (0..7).each {|x|
      pieces.append(Pawn.new([6, x], "w"))
    }

    (0..7).each {|x|
      pieces.append(Pawn.new([1, x], "b"))
    }

    pieces.append(Rook.new([7, 0], "w"))
    pieces.append(Knight.new([7, 1], "w"))
    pieces.append(Bishop.new([7, 2], "w"))
    pieces.append(Queen.new([7, 3], "w"))
    pieces.append(King.new([7, 4], "w"))
    pieces.append(Bishop.new([7, 5], "w"))
    pieces.append(Knight.new([7, 6], "w"))
    pieces.append(Rook.new([7, 7], "w"))

    pieces.append(Rook.new([0, 0], "b"))
    pieces.append(Knight.new([0, 1], "b"))
    pieces.append(Bishop.new([0, 2], "b"))
    pieces.append(Queen.new([0, 3], "b"))
    pieces.append(King.new([0, 4], "b"))
    pieces.append(Bishop.new([0, 5], "b"))
    pieces.append(Knight.new([0, 6], "b"))
    pieces.append(Rook.new([0, 7], "b"))
  end

  attr_reader :row, :col
end
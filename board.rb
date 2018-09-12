require_relative 'board_util'

class Board

  def initialize
    @board = Array.new(10) {Array.new(10)}
    @emptyboard = Array.new(10) {Array.new(10)}
    @pieces = Array.new(32)
  end

  def start
    @pieces = Board_util.new.initialize_board
  end

  def draw_pieces
    for x in @pieces
      if !x.cap
        @board = [x.loc[0]][x.loc[1]] = x.to_string
      end
    end
  end

  def draw_board
    for i in 0..7
      @board[i] = @emptyboard[i]
    end

    draw_pieces

    for x in 0..7
      print @board[x], "\n"
    end
  end

  def make_move(input)
    input = input.downcase
    inputs = input.split(" ")
    b = move_piece(inputs[0], inputs[1], "")
    if !b
      puts "Illegal move!"
    end
    b
  end

  def get_piece(pos, turn)
    pos1 = Board_util.convert_coord(pos)

    for x in @pieces
      if x.loc[0] == pos1[0] && x.loc[1] == pos1[1] && !p.cap && x.color == Chess.white_turn ? "w" : "b"
        return @pieces.index(x)
      end
    end
    -1
  end

  def move_piece(pos1, pos2, piece)
    if valid_move(pos1, pos2, Chess.white_turn)
      new_loc = Board_util.getloc(pos2)
      if get_piece(pos2, !Chess.white_turn) != -1
        p2 = @pieces[get_piece(pos2, !Chess.white_turn)]
        if p2.instance_of? King
          if Chess.white_turn
            puts "White wins!"
          else
            puts "Black wins!"
          end
        end
        p2.captured
        p2.loc = [-1, -1]
      end
      p = @pieces[get_piece(pos1, Chess.white_turn)]

      if p.instance_of? Pawn
        promotion(pos2, piece)
      end

      if !checkmake
        if (Chess.white_turn && b_check) || (!Chess.white_turn && w_check)
          puts "check"
        end
      end
      return true
    end
    false
  end

  def valid_move(pos1, pos2, turn)
    p = @pieces[get_piece(pos1, turn)]

    if correct_locs(pos1, pos2, turn)
      pos2coord = Board_util.getloc(pos2)
      return p.can_move(pos2coord[0], pos2coord[1])
    end
    false
  end

  def correct_locs(pos1, pos2, turn)
    if get_piece(pos2, turn) == -1
      return no_block(pos1, pos2, turn)
    end
    false
  end

  def no_block(pos1, pos2, turn)
    pos1coord = Board_util.getloc(pos1)
    pos2coord = Board_util.getloc(pos2)
    # go through straight
    get_piece(pos2, turn) == -1 && !diagonal_block(pos1coord, pos2coord)
  end

  def diagonal_block(pos1coord, pos2coord)
    if pos1coord[0] == pos2coord[0] || pos1coord[1] == pos2coord[1] ||
        ((pos1coord[0] - pos2coord[0] != pos1coord[1] - pos2coord[1]) || (pos1coord[0] - pos2coord[0] != -(pos1coord[1] - pos2coord[1])))
      return false
    else
      y =
          for x in pos1coord[0]..pos2coord[0]

          end
    end
    false
  end

  def promotion(pos2, piece)
    p = @pieces[get_piece(pos2, Chess.white_turn)]
    if ((p.color == "w" && p.loc[0] == 0) || (p.color == "b" && p.loc[0] == 7)) && p.instance_of?
      Pawn
      case piece
      when "N"
        @pieces[get_piece(pos2, Chess.white_turn)] = Knight.new(p.loc, p.color)
      when "B"
        @pieces[get_piece(pos2, Chess.white_turn)] = Bishop.new(p.loc, p.color)
      when "R"
        @pieces[get_piece(pos2, Chess.white_turn)] = Rook.new(p.loc, p.color)
      else
        @pieces[get_piece(pos2, Chess.white_turn)] = Queen.new(p.loc, p.color)
      end
    end
  end

  def b_check
    bk = @pieces[28]
    @pieces.each {|x|
      if x.color == "w" && !x.cap
        if valid_move(Board_util.convert_coord(x.loc), Board_util.convert_coord(bk.loc), true)
          return true
        end
      end
    }
    false
  end

  def w_check
    wk = @pieces[28]
    @pieces.each {|x|
      if x.color == "b" && !x.cap
        if valid_move(Board_util.convert_coord(x.loc), Board_util.convert_coord(wk.loc), true)
          return true
        end
      end
    }
    false
  end

  def checkmate

  end
end
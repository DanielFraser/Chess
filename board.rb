require_relative 'board_util'

class Board
  def initialize
    @board = Array.new(8) {Array.new(8)}
    @empty_board = Array.new(8) {Array.new(8)}
    @pieces = []
    @piece_locations = {}
    init_empty
  end

  def init_empty
    row = [" # # # #", "# # # # "]
    (0..7).each {|i|
      @empty_board[i] = row[i % 2].dup
    }
  end

  def start
    @pieces = BoardUtil.initialize_board
    (0..@pieces.length - 1).each {|i|
      @piece_locations[p.loc] = i
    }
  end

  def draw_pieces
    @pieces.each do |x|
      @board[x.loc[0]][x.loc[1]] = x.to_string unless x.cap
    end
  end

  def draw_board
    @board = Marshal.load(Marshal.dump(@empty_board))

    draw_pieces

    require 'colorize'

    (0..7).each {|i|
      (0..7).each {|j|
        case get_color([i, j])
        when "w"
          print @board[i][j].white
        when "b"
          print @board[i][j].blue
        else
          print @board[i][j]
        end
      }
      print "\n"
    }
  end

  def get_color(pos)
    if @piece_locations.key?(pos)
      @board[@piece_locations[pos]].color
    end
    'none'
  end

  # splits input and tries to move piece
  def make_move(input)
    input = input.downcase
    inputs = input.split(' ')
    inputs.append('') if inputs.length < 3
    if get_piece(BoardUtil.getloc(inputs[0]), Chess.white_turn ? "w" : "b") == -1 || !move_piece(inputs[0], inputs[1], inputs[2])
      puts 'Illegal move!'
      return false
    end
    true
  end

  # return piece at certain location or -1 if no piece
  def get_piece(pos, turn)
    pos1 = BoardUtil.getloc(pos)
    if [true, false].include? turn
      turn = turn ? "w" : "b"
    end
    if @piece_locations.key?(pos1)
      return @piece_locations[pos1] if @pieces[@piece_locations[pos1]].color == turn ? 'w' : 'b'
    end
    -1
  end

  # move piece if nothing is blocking
  def move_piece(pos1, pos2, piece)
    if valid_move(pos1, pos2, Chess.white_turn)
      new_loc = BoardUtil.getloc(pos2)
      if get_piece(pos2, !Chess.white_turn) != -1
        p2 = @pieces[get_piece(pos2, !Chess.white_turn)]
        if p2.instance_of? King
          if Chess.white_turn
            puts 'White wins!'
          else
            puts 'Black wins!'
          end
        end
        p2.captured
        p2.loc = [-1, -1]
      end
      p = @pieces[get_piece(pos1, Chess.white_turn)]

      promotion(pos2, piece) if p.instance_of? Pawn

      unless checkmate
        if (Chess.white_turn && b_check) || (!Chess.white_turn && w_check)
          puts 'check'
        end
      end
      return true
    end
    false
  end

  #
  def valid_move(pos1, pos2, turn)
    p = @pieces[get_piece(pos1, turn)]

    if no_block(pos1, pos2, turn)
      pos2coord = BoardUtil.getloc(pos2)
      return p.can_move(pos2coord[0], pos2coord[1])
    end
    false
  end

  # check if anything is blocking path
  def no_block(pos1, pos2, turn)
    pos1coord = BoardUtil.getloc(pos1)
    pos2coord = BoardUtil.getloc(pos2)
    # go through straight
    !straight_block(pos1coord, pos2coord) && !diagonal_block(pos1coord, pos2coord)
  end

  # is piece being blocked from N, S, E, or W?
  def straight_block(pos1, pos2)
    pos1coord = BoardUtil.getloc(pos1)
    pos2coord = BoardUtil.getloc(pos2)
    if pos1coord[0] == pos2coord[0]
      i = pos1coord[1]
      while i != pos2coord[1]
        return true if has_piece([pos1coord[0], i])
        if i < pos2coord[1]
          i += 1
        else
          i -= 1
        end
      end
    end
    false
  end

  def has_piece(pos1coord)
    return true if get_piece(pos1coord, "w") || get_piece(pos1coord, "b")
    false
  end

  def diagonal_block(pos1coord, pos2coord)
    if pos1coord[0] == pos2coord[0] || pos1coord[1] == pos2coord[1] ||
        ((pos1coord[0] - pos2coord[0] != pos1coord[1] - pos2coord[1]) || (pos1coord[0] - pos2coord[0] != -(pos1coord[1] - pos2coord[1])))
      return false
    else
      rows = []
      cols = []
      if pos1coord[0] > pos2coord[0]
        rows = Array(pos2coord[0], pos1coord[0])
      else
        rows = Array(pos1coord[0], pos2coord[0])
      end
      if pos1coord[1] > pos2coord[1]
        cols = Array(pos2coord[1], pos1coord[1])
      else
        cols = Array(pos1coord[1], pos2coord[1])
      end
      i = 0
      while i < cols.length
        if has_piece([rows[i], cols[i]])
          return true
        end
        i += 1
      end
    end
    false
  end

  def promotion(pos2, piece)
    p = @pieces[get_piece(pos2, Chess.white_turn)]
    if ((p.color == 'w' && p.loc[0] == 0) || (p.color == 'b' && p.loc[0] == 7)) && p.instance_of? Pawn
      @pieces[get_piece(pos2, Chess.white_turn)] = case piece
                                                   when 'N'
                                                     Knight.new(p.loc, p.color)
                                                   when 'B'
                                                     Bishop.new(p.loc, p.color)
                                                   when 'R'
                                                     Rook.new(p.loc, p.color)
                                                   else
                                                     Queen.new(p.loc, p.color)
                                                   end
    end
  end

  def b_check
    bk = @pieces[28]
    @pieces.each do |x|
      next unless x.color == 'w' && !x.cap
      if valid_move(BoardUtil.convert_coord(x.loc), BoardUtil.convert_coord(bk.loc), true)
        return true
      end
    end
    false
  end

  def w_check
    wk = @pieces[28]
    @pieces.each do |x|
      next unless x.color == 'b' && !x.cap
      if valid_move(BoardUtil.convert_coord(x.loc), BoardUtil.convert_coord(wk.loc), true)
        return true
      end
    end
    false
  end

  def checkmate
    if w_check
      coords = @pieces[20].loc
      cm = true
      k = -1

      if out_of_checkw
        cm = false
      else
        @pieces[20].possible_moves.each {|x|
          if valid_move(BoardUtil.convert_coord(coords), BoardUtil.convert_coord(x), true)
            @pieces[20].loc = x
            if get_piece(BoardUtil.convert_coord(x), false) != -1
              k = get_piece(BoardUtil.convert_coord(x), false)
              @pieces[k].captured
            end

            cm = cm && w_check
            if k != -1
              @pieces[k].cap = false
            end
          end
          @pieces[20].loc = coords
        }
      end

      if cm
        puts "Checkmate!"
        puts "Black Wins!"
        Chess.end_game
        return true
      end
    end
    if b_check
      coords = @pieces[28].loc
      cm = true
      k = -1

      if out_of_checkb
        cm = false
      else
        @pieces[28].possible_moves.each {|x|
          if valid_move(BoardUtil.convert_coord(coords), BoardUtil.convert_coord(x), false)
            @pieces[28].loc = x
            if get_piece(BoardUtil.convert_coord(x), true) != -1
              k = get_piece(BoardUtil.convert_coord(x), true)
              @pieces[k].captured
            end

            cm = cm && w_check
            if k != -1
              @pieces[k].cap = false
            end
          end
          @pieces[28].loc = coords
        }
      end

      if cm
        puts "Checkmate!"
        puts "White Wins!"
        Chess.end_game
        return true
      end
    end
  end

  def out_of_check(color)
    k = -1
    for x in @pieces
      if x.color == color && !x.cap && !(x.instance_of? King)
        pos_moves = x.possible_moves
        cur_loc = x.loc
        for y in pos_moves
          if valid_move(BoardUtil.convert_coord(x.loc), BoardUtil.convert_coord(y), color == "w")
            x.loc = y
            if get_piece(BoardUtil.convert_coord(y), color != "w")
              k = get_piece(BoardUtil.convert_coord(y), color != "w")
              @pieces[k].captured
            end

            if w_check
              if k != -1
                @pieces[k].cap = false
              end
              k = -1
              x.loc = cur_loc
              return true
            end
            if k != -1
              @pieces[k].cap = false
            end
          end
        end
      end
    end
    false
  end
end

require_relative 'board_util'

class Board

  def initialize
    @board = Array.new(10) { Array.new(10)}
    @emptyboard = Array.new(10) { Array.new(10)}
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
   b = move_piece(inputs[0], inputs[1])
   if !b
     puts "Illegal move!"
   end
   b
 end

  def move_piece

  end
end
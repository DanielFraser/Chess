require_relative 'board_util'
require_relative 'board'

class Chess

  @@white_turn = true
  @draw = false
  @game_end = false


  def self.main
    Board_util.init_hash
    board = Board.new

    board.start

    until @game_end
      board.draw_board
      valid_move = false
      until valid_move
        if white_turn
          print "White's move: "
        else
          print "Black's move: "
        end
        user_input = gets.chomp
        puts user_input
        valid_move = board.make_move(user_input)
      end
      puts ''
      @@white_turn = !@@white_turn
    end
  end

  def self.white_turn
    @@white_turn
  end

  def self.end_game
    @game_end = true
  end
end

Chess.main
class Chess

  def initialize
    @@white_turn = true
    @draw = false
    @game_end = false
  end

  def self.main
    Board_util.init_hash
    board = Board.new

    board.start

    until @game_end
      board.draw_board
      valid_move = false
      until valid_move
        white_turn ? print "White's move: " : print "Black's move: "
        user_input = gets.chomp
        valid_move = board.make_move(user_input)
      end
      puts ""
      @@white_turn = !@@white_turn
    end
  end

  def self.white_turn
    @@white_turn
  end

end

Chess.main
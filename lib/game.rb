class Game
  attr_reader :board, :current_player, :player1, :player2

  def initialize(player1, player2)
    @board = Board.new
    @player1 = Player.new(player1, :red)
    @player2 = Player.new(player2, :yellow)
    @current_player = @player1
  end

  def player_turn(column)
    return false unless board.valid_move?(column)

    board.place_piece(column, current_player.color)

    if board.winner?
      :win
    elsif board.draw?
      :draw
    else
      switch_turn
      :continue
    end
  end

  def play
    loop do
      board.print_board
      puts "#{current_player.name}, choose a column (1-7):"
      column = gets.chomp.to_i
      result = player_turn(column)

      case result
      when :win
        board.print_board
        puts "#{current_player.name} wins!"
        break
      when :draw
        board.print_board
        puts "It's a draw!"
        break
      when :continue
        next
      else
        puts 'Invalid move. Try again!'
      end
    end
  end

  private

  def switch_turn
    @current_player = @current_player == player1 ? player2 : player1
  end
end

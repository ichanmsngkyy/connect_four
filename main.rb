require_relative 'lib/board'

board = Board.new
board.print_board
(1..7).each { |col| 6.times { board.place_piece(col, col.odd? ? :red : :yellow) } }
board.print_board  # Verify board is fully filled
puts board.winner? # Ensure this returns false
puts board.draw?   # Expected: true

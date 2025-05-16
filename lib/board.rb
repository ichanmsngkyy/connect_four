# frozen_string_literal: true

# Board class for Connect Four
class Board
  DEFAULT_ROWS = 6
  DEFAULT_COLS = 7
  def initialize
    @board = Array.new(DEFAULT_ROWS) { Array.new(DEFAULT_COLS, nil) }
  end

  def print_board
    @board.each do |row|
      print '|'
      row.each do |cell|
        symbol = case cell
                 when nil then '⚪'
                 when :red then '🔴'
                 when :yellow then '🟡'
                 else cell.to_s
                 end
        print "#{symbol}|"
      end
      puts
    end

    # Create divider line based on board width
    puts '-' * (2 * @board.first.length + 1)

    # Create column numbers based on board width
    print ' '
    (1..@board.first.length).each do |i|
      printf('%2d ', i)
    end
    puts
  end

  def place_piece(column, color)
    col_index = column - 1
    return false unless col_index.between?(0, 6)

    (0..5).reverse_each do |row|
      if @board[row][col_index].nil?
        @board[row][col_index] = color
        return true
      end
    end
    false
  end

  def valid_move?(column)
    col_index = column - 1
    col_index.between?(0, @board[0].length - 1) && !column_full?(col_index)
  end

  private

  def column_full?(col_index)
    @board.all? { |row| !row[col_index].nil? }
  end
end

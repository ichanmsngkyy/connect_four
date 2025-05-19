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

    puts '-' * (2 * @board.first.length + 1)

    print ' '
    (1..@board.first.length).each do |i|
      printf(" #{i} ")
    end
    puts
  end

  def place_piece(column, color)
    col_index = column - 1
    return false unless valid_move?(column)

    (DEFAULT_ROWS - 1).downto(0) do |row|
      next unless @board[row][col_index].nil?

      @board[row][col_index] = color
      return true
    end
    false
  end

  def valid_move?(column)
    col_index = column - 1
    col_index.between?(0, @board[0].length - 1) && !column_full?(col_index)
  end

  def winner?
    check_horizontal_win? || check_vertical_win? || check_diagonal_win?
  end

  def full?
    @board.flatten.all? { |cell| !cell.nil? }
  end

  def draw?
    full? && !winner?
  end

  private

  def column_full?(col_index)
    !@board[0][col_index].nil?
  end

  def consecutive_four?(array)
    return false if array.size < 4

    array.each_cons(4).any? { |window| window.uniq.size == 1 && !window.include?(nil) }
  end

  def check_horizontal_win?
    @board.any? { |row| consecutive_four?(row) }
  end

  def check_vertical_win?
    @board.transpose.any? { |column| consecutive_four?(column) }
  end

  def check_diagonal_win?
    diagonals_left_to_right.any? { |diagonal| consecutive_four?(diagonal) } ||
      diagonals_right_to_left.any? { |diagonal| consecutive_four?(diagonal) }
  end

  def diagonals_left_to_right
    (0..@board.length - 4).flat_map do |row|
      (0..@board[0].length - 4).map do |col|
        (0..3).map { |i| @board[row + i][col + i] }
      end
    end
  end

  def diagonals_right_to_left
    (0..@board.length - 4).flat_map do |row|
      (0..@board[0].length - 4).map do |col|
        (0..3).map { |i| @board[row + i][col + 3 - i] }
      end
    end
  end
end

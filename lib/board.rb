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
      return winner?
    end
    false
  end

  def valid_move?(column)
    col_index = column - 1
    col_index.between?(0, @board[0].length - 1) && !column_full?(col_index)
  end

  def winner?
    false if @board.nil? || @board.empty?
    check_horizontal_win? || check_vertical_win? || check_diagonal_win?
  end

  def full?
    @board.flatten.none?(&:nil?)
  end

  def draw?
    full? && !winner?
  end

  def get_board_state
    @board.map(&:dup)
  end

  private

  def column_full?(col_index)
    !@board[0][col_index].nil?
  end

  def check_diagonal_win?
    check_left_to_right_diagonal? || check_right_to_left_diagonal?
  end

  def check_horizontal_win?
    @board.each do |row|
      next if row.compact.empty?

      (0..row.length - 4).each do |col|
        window = row[col, 4]
        next if window.any?(&:nil?)

        return true if window.uniq.size == 1
      end
    end
    false
  end

  def check_vertical_win?
    @board.transpose.each do |column|
      next if column.compact.empty?

      (0..column.length - 4).each do |row|
        window = column[row, 4]
        next if window.any?(&:nil?)

        return true if window.uniq.size == 1
      end
    end
    false
  end

  def check_left_to_right_diagonal?
    (0..@board.length - 4).each do |start_row|
      (0..@board[0].length - 4).each do |start_col|
        window = []
        4.times do |i|
          window << @board[start_row + i][start_col + i]
        end
        next if window.any?(&:nil?)
        return true if window.uniq.size == 1
      end
    end
    false
  end

  def check_right_to_left_diagonal?
    (0..@board.length - 4).each do |start_row|
      (3..@board[0].length - 4).each do |start_col|
        window = []
        4.times { |i| window << @board[start_row + i][start_col + i] }
        next if window.any?(&:nil?)
        return true if window.uniq.size == 1
      end
    end
    false
  end
end

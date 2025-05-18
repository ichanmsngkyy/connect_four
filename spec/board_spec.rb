# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  attr_reader :board

  subject(:board) { described_class.new }

  describe '#initialize' do
    it 'creates an empty 7x6 board' do
      expected_board = Array.new(6) { Array.new(7, nil) }
      expect(board.instance_variable_get(:@board)).to eq(expected_board)
    end
  end

  describe '#print_board' do
    it 'prints the board' do
      expected_output = <<~BOARD
        |⚪|⚪|⚪|⚪|⚪|⚪|⚪|
        |⚪|⚪|⚪|⚪|⚪|⚪|⚪|
        |⚪|⚪|⚪|⚪|⚪|⚪|⚪|
        |⚪|⚪|⚪|⚪|⚪|⚪|⚪|
        |⚪|⚪|⚪|⚪|⚪|⚪|⚪|
        |⚪|⚪|⚪|⚪|⚪|⚪|⚪|
        ---------------
          1  2  3  4  5  6  7#{' '}
      BOARD
      expect { board.print_board }.to output(expected_output).to_stdout
    end

    it 'prints pieces correctly' do
      board.place_piece(1, :red)
      board.place_piece(1, :yellow)
      expected_output = <<~BOARD
        |⚪|⚪|⚪|⚪|⚪|⚪|⚪|
        |⚪|⚪|⚪|⚪|⚪|⚪|⚪|
        |⚪|⚪|⚪|⚪|⚪|⚪|⚪|
        |⚪|⚪|⚪|⚪|⚪|⚪|⚪|
        |🟡|⚪|⚪|⚪|⚪|⚪|⚪|
        |🔴|⚪|⚪|⚪|⚪|⚪|⚪|
        ---------------
          1  2  3  4  5  6  7#{' '}
      BOARD
      expect { board.print_board }.to output(expected_output).to_stdout
    end
  end

  describe '#place_piece' do
    let(:board) { described_class.new }
    it 'places a piece at the bottom of an empty column' do
      board.place_piece(1, :red)
      board.place_piece(1, :yellow)

      grid = board.instance_variable_get(:@board)
      expect(grid[5][0]).to eq(:red)
      expect(grid[4][0]).to eq(:yellow)
    end

    it 'returns false if the column is full' do
      6.times { board.place_piece(1, :red) }
      expect(board.place_piece(1, :yellow)).to be false
    end

    it 'returns for invalid columns' do
      expect(board.place_piece(0, :red)).to be false
      expect(board.place_piece(9, :yellow)).to be false
    end
  end

  describe '#valid_move?' do
    it 'works with default 7-column board' do
      expect(board.valid_move?(1)).to be true
      expect(board.valid_move?(7)).to be true
      expect(board.valid_move?(8)).to be false
    end
    it 'returns true for a non full-column' do
      expect(board.valid_move?(3)).to be true
    end

    it 'returns false for a full column' do
      6.times { board.place_piece(1, :red) }
      expect(board.place_piece(1, :yellow)).to be false
    end
  end

  describe '#winner?' do
    it 'returns false for an empty board' do
      expect(board.winner?).to be false
    end

    it 'returns false for a partially filled board with no wins' do
      board.place_piece(1, :red)
      board.place_piece(2, :yellow)
      expect(board.winner?).to be false
    end

    context 'horizontal wins' do
      it 'returns true for four consecutive red places in a row' do
        (1..4).each { |col| board.place_piece(col, :red) }
        expect(board.winner?).to be true
      end

      it 'returns true for four consecutive yellow places in a row' do
        (1..4).each { |col| board.place_piece(col, :yellow) }
        expect(board.winner?).to be true
      end
    end

    context 'vertical wins' do
      it 'returns true for four consecutive red places in a column' do
        4.times { board.place_piece(1, :red) }
        expect(board.winner?).to be true
      end

      it 'returns true for four consecutive yellow places in a column' do
        4.times { board.place_piece(3, :yellow) }
        expect(board.winner?).to be true
      end
    end

    context 'diagonal wins' do
      it 'detects left-to-right diagonal wins (\)' do
        (0..3).each do |offset|
          (offset + 1).times { board.place_piece(offset + 1, :red) }
        end
      end

      it 'detects right-to-left diagonal wins (/)' do
        (0..3).each do |offset|
          (offset + 1).times { board.place_piece(7 - offset, :yellow) }
        end
        expect(board.winner?).to be true
      end
    end
  end

  describe '#draw?' do
    it 'returns false for an empty board' do
      expect(board.draw?).to be false
    end

    it 'returns false when the board is not full' do
      board.place_piece(1, :red)
      expect(board.draw?).to be false
    end

    it 'returns true when the board is full and no winner' do
      moves = [
        [1, :yellow], [2, :red], [3, :red], [4, :yellow], [5, :red], [6, :yellow], [7, :red],
        [7, :yellow], [6, :red], [5, :yellow], [4, :yellow], [3, :red], [2, :yellow], [1, :yellow],
        [1, :red], [2, :red], [3, :yellow], [4, :red], [5, :yellow], [6, :yellow], [7, :red],
        [7, :yellow], [6, :red], [5, :yellow], [4, :red], [3, :yellow], [2, :yellow], [1, :yellow],
        [5, :red], [4, :red], [3, :red], [2, :yellow], [1, :red], [6, :yellow], [7, :red],
        [7, :yellow], [6, :red], [5, :yellow], [4, :yellow], [3, :red], [2, :red], [1, :yellow]
      ]

      moves.each { |col, color| board.place_piece(col, color) }

      board.print_board # Debugging step
      puts "Winner detected? #{board.winner?}" # Should be nil
      puts "Board full? #{board.full?}" # Should be true

      expect(board.draw?).to be true
    end
  end
end

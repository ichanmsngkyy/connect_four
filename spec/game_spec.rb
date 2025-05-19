require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/player'

describe Game do
  subject(:game) { described_class.new('Kuma', 'Sobbie') }

  describe '#player_turn' do
    context 'when the move is valid' do
      it 'places the piece on the board' do
        game.player_turn(1)

        row_index = game.board.instance_variable_get(:@board).rindex { |row| row[0] == :red }

        expect(row_index).not_to be_nil
        expect(game.board.instance_variable_get(:@board)[row_index][0]).to eq(:red)
      end

      it 'switches to the next player after a move' do
        expect(game.current_player).to eq(game.player1)
        game.player_turn(1)
        expect(game.current_player).to eq(game.player2)
      end
    end

    context 'when the move results in a win' do
      it 'returns :win when a winning move is made' do
        3.times do
          game.player_turn(1)
          game.player_turn(2)
        end
        result = game.player_turn(1)

        expect(result).to eq(:win)
      end
    end

    context 'when the move results in a draw' do
      it 'returns :draw when the board is full with no winner' do
        (1..7).each { |col| 3.times { game.player_turn(col) } }
        (1..7).each { |col| 3.times { game.player_turn(col) } }
        result = game.player_turn(7)

        expect(result).to eq(false)
      end
    end

    context 'when the move is invalid' do
      it 'does not change the board for an invalid move' do
        allow(game.board).to receive(:valid_move?).and_return(false)

        expect(game.player_turn(8)).to be false
        expect(game.board.instance_variable_get(:@board).flatten).to all(be_nil)
      end

      it 'does not switch players after an invalid move' do
        allow(game.board).to receive(:valid_move?).and_return(false)

        expect(game.current_player).to eq(game.player1)
        game.player_turn(8)
        expect(game.current_player).to eq(game.player1)
      end
    end
  end
end

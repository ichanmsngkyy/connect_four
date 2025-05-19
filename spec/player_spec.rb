# frozen_string_literal: true

require_relative '../lib/player'

describe Player do
  subject(:player1) { described_class.new('Kuma', :red) }
  subject(:player2) { described_class.new('Sobbie', :yellow) }

  describe '#initialize' do
    it 'sets the player 1 name correctly' do
      expect(player1.name).to eq('Kuma')
    end

    it 'sets the player 1 color to red correctly' do
      expect(player1.color).to eq(:red)
    end

    it 'sets the player 2 name correctly' do
      expect(player2.name).to eq('Sobbie')
    end

    it 'sets the player 2 color to yellow correctly' do
      expect(player2.color).to eq(:yellow)
    end
  end
end

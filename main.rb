# frozen_string_literal: true

require_relative 'lib/board'
require_relative 'lib/game'
require_relative 'lib/player'

game = Game.new('Player 1', 'Player 2')
game.play

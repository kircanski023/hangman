require_relative "lib/player"
require_relative "lib/game"

new_game = Game.new

new_game.generate_word
player = Player.new

player.input

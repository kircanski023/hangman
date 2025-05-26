require_relative "lib/player"
require_relative "lib/game"

def play
  new_game = Game.new
  puts "Saved game found. Continue? (y/n)"
  choice = gets.chomp.downcase
  if choice == "y"
    data = File.read("save.json")
    new_game.unserialize(data)
    new_game.start_game
  elsif choice == "n"
    new_game.start_game
  end
end

play

require_relative "serializable"
# Player class
class Player
  include BasicSerializable
  def initialize
    @guess = ""
    @final_guess = ""
    @choice = 0
  end
  attr_accessor :guess, :final_guess, :choice

  def input
    reset
    make_choice
    if choice == 1
      puts "Choose letter: "
      self.guess = gets.chomp.chars.first
    elsif choice == 2
      puts "Choose word: "
      self.final_guess = gets.chomp.chars
    end
  end

  def to_h
    {
      guess: @guess,
      final_guess: @final_guess,
      choice: @choice
    }
  end

  def self.from_h(hash)
    player = new
    player.guess = hash["guess"]
    player.final_guess = hash["final_guess"]
    player.choice = hash["choice"]
    player
  end

  private

  def make_choice
    puts "Press number to choose: \n1. Guess letter 2. Guess word\n--------------------------"
    until [1, 2].include?(choice)
      puts "Choose 1 or 2\n--------------------------" unless [1, 2].include?(choice)
      self.choice = gets.chomp.to_i
    end
  end

  def reset
    @guess = ""
    @final_guess = ""
    @choice = 0
  end
end

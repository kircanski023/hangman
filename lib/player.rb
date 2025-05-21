# Player class
class Player
  def initialize
    @guess = []
  end
  attr_accessor :guess

  def input
    @guess = []
    guess.push(gets.chomp.chars.first)
  end
end

# class Game
class Game
  def initialize
    @rand_word = ""
    generate_word
    @player = Player.new
    @result = Array.new(rand_word.length)
  end
  attr_accessor :rand_word, :result

  def generate_word
    File.open("words.txt", "r") do |file|
      self.rand_word = file.map do |word|
        word.chomp if word.chomp.length > 5 && word.chomp.length < 12
      end.compact.sample
    end
  end
end

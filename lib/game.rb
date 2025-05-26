require_relative "serializable"

# class Game
class Game
  include BasicSerializable

  def initialize
    @rand_word = ""
    generate_word
    @player = Player.new
    @result = Array.new(rand_word.length)
    @incorrect = []
  end
  attr_accessor :rand_word, :result

  def generate_word
    File.open("words.txt", "r") do |file|
      self.rand_word = file.map do |word|
        word.chomp if word.chomp.length > 5 && word.chomp.length < 12
      end.compact.sample.chars
    end
  end

  def valid?
    @player.input
    if rand_word.include?(@player.guess)
      true
    else
      @incorrect.push(@player.guess) unless @incorrect.include?(@player.guess)
      false
    end
  end

  def write_to_result
    if @player.choice == 1
      rand_word.each_with_index do |item, index|
        @result[index] = @player.guess if item == @player.guess
      end
    elsif @player.choice == 2
      @result = @player.final_guess.dup if rand_word == @player.final_guess
    end
  end

  def game_over?
    if result == rand_word
      puts "Correct! You win!"
      true
    else
      false
    end
  end

  def start_game # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    i = 30 - @incorrect.length # resume based on incorrect guesses

    while i.positive?
      break if game_over?

      i -= 1 unless valid?
      write_to_result
      p result
      puts "Incorrect letters: #{@incorrect}\n--------------------------" unless @incorrect.empty?
      puts "Attempts remaining #{i}\n--------------------------"

      # Offer to save and exit
      puts "Type 'save' to save and exit, or press Enter to continue:" unless game_over?
      input = gets.chomp unless game_over?
      next unless input.downcase == "save"

      File.write("save.json", serialize)
      puts "Game saved. Goodbye!"
      return
    end

    puts "The word was: #{rand_word.join}" unless game_over?
  end

  def serialize
    obj = {}
    instance_variables.each do |var|
      value = instance_variable_get(var)

      # Special handling for @player
      obj[var] = if var == :@player
                   { "__player__" => @player.to_h }
                 else
                   value
                 end
    end
    JSON.dump(obj)
  end

  def unserialize(string)
    obj = JSON.parse(string)
    obj.each do |key, value|
      if key == "@player" && value.is_a?(Hash) && value.key?("__player__")
        instance_variable_set(:@player, Player.from_h(value["__player__"]))
      else
        instance_variable_set(key.to_sym, value)
      end
    end
  end
end

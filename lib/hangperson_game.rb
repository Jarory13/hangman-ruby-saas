class HangpersonGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_reader :turn_counter
  attr_reader :display
  attr_reader :win_counter
  
  def initialize(new_word)
    @word = new_word.downcase
    @guesses = ''
    @wrong_guesses = ''
    @turn_counter = 0
    @display = ''
    @win_counter = 0
  end
  
  
  
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end


  #Method to handle guessing logic. 
  # @param is the letter guessed by the user
  def guess(letter)
    raise(ArgumentError, "You must enter a letter") if (letter =~ /[^a-z]/i) 
     raise(ArgumentError, "You must enter a letter") if !letter || letter.empty?  #for some reason letter.blank? doesn't work. 
     #I'll need to update this to handle multiple letter inputs. Though this line might not be needed since App.rb only passes
     #A single letter at a time. 
     #raise(ArgumentError, "Enter only one letter") if (letter.length > 1) 
    @turn_counter +=1
    letter.downcase!
   
        if (guesses.include? letter) | (wrong_guesses.include? letter) 
        false
        else 
            if word.include? letter
              @guesses += letter
              @win_counter +=1
            else 
              @wrong_guesses += letter
            end
        end
  end


  #Method to display guessed words. Uses "-" to display letters that aren't gussed. 
  def word_with_guesses
  display = ''
    word.each_char do |a|
      if @guesses.include? a
          display += a
      else
          display += "-"
      end
    end
    display 
  end

  #Method to check game state. Returns a symbol for :wins, :lose, or keep playing (:play)
  def check_win_or_lose
    if win_counter >= word.split("").uniq.length then return :win end
    @turn_counter > 8 ? :lose : :play
  end
  
end

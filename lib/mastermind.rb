# frozen_string_literal: true

require './lib/code.rb'
require './lib/colors.rb'
require './lib/player.rb'

class Game
  include Colors
  include Code

  attr_reader :codemaker, :codebreaker, :code, :guesses, :game_over
  MAX_GUESSES = 12

  def initialize(codemaker, codebreaker)
    @code = Array.new(4, :blank)
    @game_over = false
    @guesses = 0
    @codemaker = codemaker
    @codebreaker = codebreaker
  end

  def play
    @code = codemaker.ask_for_code

    until @game_won || (@guesses > MAX_GUESSES)
      guesses_left = MAX_GUESSES - guesses

      if guesses_left == 0
        puts 'Last guess'
      else
        puts "#{guesses_left} guesses left."
      end

      guess = @codebreaker.ask_for_guess

      if guess_correct?(code, guess)
        @game_won = true
      else
        puts "\n\nSorry, your guess was incorrect: #{print_code(guess)}"
        critique = critique_code(@code, guess)
        @codebreaker.provide_feedback(critique)
      end

      @guesses += 1
    end

    if @game_won
      puts "\n\nCorrect! You've won! The code was: #{print_code(@code)}"
    else
      puts "\n\nBetter luck next time. The code was: #{print_code(@code)}"
    end
  end
end

print 'Welcome. Would you like to be codebreaker? [Y/n] >> '
input = gets.chomp.downcase

g = if input == 'n' || input == 'no'
      Game.new(Human.new, Computer.new)
    else
      Game.new(Computer.new, Human.new)
    end

g.play

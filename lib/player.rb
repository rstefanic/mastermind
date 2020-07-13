# frozen_string_literal: true

require './lib/ai.rb'
require './lib/code.rb'
require './lib/colors.rb'

# Base Player Class
class Player
  include Colors
  include Code
end

# Human Player
class Human < Player
  def ask_for_code
    current_code = Array.new(4, :blank)
    i = 0

    print_color_choices

    while i < current_code.length
      print "\n\n"
      puts 'Current code: ' + print_code(current_code) + "\n"
      print "Code Slot # #{i + 1} >> "
      input = gets.chomp.to_i
      input -= 1

      if valid_choice? input
        current_code[i] = COLORS[input]
      else
        print "\n"
        puts 'ERR: Invalid color selection. Please try again.'
        print_color_choices
        next
      end

      i += 1
    end

    puts "The code to break is #{print_code(current_code)}."

    current_code
  end

  def ask_for_guess
    current_guess = Array.new(4, :blank)
    i = 0

    print_color_choices

    while i < current_guess.length
      print "\n\n"
      puts 'Current guess: ' + print_code(current_guess) + "\n"
      print "Guess Slot # #{i + 1} >> "
      input = gets.chomp.to_i
      input -= 1

      if valid_choice? input
        current_guess[i] = COLORS[input]
      else
        print "\n"
        puts 'ERR: Invalid color selection. Please try again.'
        print_color_choices
        next
      end

      i += 1
    end

    current_guess
  end

  def provide_feedback(critique)
    raise 'Invalid Critique' if critique.length > 4

    print "\tCritique: "

    critique_to_strings(critique).each do |c|
      print "#{c} "
    end

    print "\n"
  end
end

# Computer Player
class Computer < Player
  include AI
  attr_reader :previous_guesses, :possibilities, :critiques

  def initialize
    @previous_guesses = []
    @critiques = []
    @possibilities = generate_possibilities
  end

  def ask_for_code
    generate_random_colors
  end

  def ask_for_guess
    if @previous_guesses.empty?
      guess = initial_guess(possibilities)
      @previous_guesses << guess.dup
      return color_confidence_to_color(guess)
    end

    guess = build_guess(previous_guesses, @possibilities)
    @previous_guesses << guess.dup
    color_confidence_to_color(guess)
  end

  def provide_feedback(critique)
    # Add the lastest critique
    @critiques << critique

    # look at the previous guess
    last_guess = @previous_guesses.last

    @possibilities = adjust_confidences(@possibilities, last_guess, critique)
  end
end

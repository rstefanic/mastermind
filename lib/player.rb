# frozen_string_literal: true

require './lib/ai.rb'
require './lib/code.rb'
require './lib/colors.rb'
require './lib/color_confidence.rb'

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
  attr_reader :colors, :previous_guesses

  def initialize
    @previous_guesses = []
    @colors = []
  end

  def ask_for_code
    generate_random_colors
  end

  def ask_for_guess
    if colors.empty?
      # Return a new guess if we have no confidence in any colors
      return generate_random_colors
    end

    current_guess = build_guess_with_confident_colors(colors)
    current_guess = build_guess_with_unconfident_colors(colors, current_guess)

    # Fill in any remaining blanks with random guesses
    if current_guess.any?(nil)
      current_guess = current_guess.map do |g|
        if g.nil?
          current_guess[i] = COLORS.sample
        end
      end
    end

    @guesses << current_guess.dup
    color_confidence_to_color(current_guess)
  end

  def provide_feedback(critique)
    # Add the lastest critique
    @critiques << critique

    # look at the previous guess
    previous_guess = @guesses.last

    # Once we get the critique back, we need to modify our color confidences
    # if any are correct, increase those colors by +25
    # if any are misplaced, increase by +10
    

  end
end

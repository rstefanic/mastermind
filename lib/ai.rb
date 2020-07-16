# frozen_string_literal: true

require './lib/possibility.rb'
require './lib/colors.rb'

# The brain is the AI code for the Computer
module AI
  include Colors

  def generate_random_colors
    current_code = Array.new(4, :blank)

    current_code[0] = COLORS.sample
    current_code[1] = COLORS.sample
    current_code[2] = COLORS.sample
    current_code[3] = COLORS.sample

    current_code
  end

  def order_colors_by_confidence(possibilities)
    possibilities.sort_by(&:confidence).reverse
  end

  def color_confidence_to_color(colors)
    raise 'Invalid color length' unless colors.length == 4

    colors.map(&:color)
  end

  def build_guess(previous_guesses, possibilities)
    current_guess = Array.new(4)
    possible_colors = order_colors_by_confidence(possibilities)

    possible_colors.each do |possibility|
      next if possibility.impossible

      current_guess[possibility.position] = possibility if current_guess[possibility.position].nil?
    end

    if current_guess.any?(nil)
      # start re-evaluating the ones we've deemed impossible
      current_guess = current_guess.each_with_index.map do |g, i|
        if g.nil?
          possible_colors.select { |p| p.position == i }.sample
        else
          g
        end
      end
    end

    # We never want to submit the same guess, so swap our least confidence guess
    if previous_guesses.include?(current_guess)
      # highest_possibility = current_guess.max_by(&:confidence)
      lowest_possibility = current_guess.min_by(&:confidence)
      position_to_substitute = lowest_possibility.position

      next_best_guesses = possibilities.select do |p|
        p.position == position_to_substitute &&
          p.color != lowest_possibility.color &&
          !p.impossible
      end

      while previous_guesses.include?(current_guess) && next_best_guesses.count.positive?
        random_substitution = next_best_guesses.sample
        next_best_guesses.reject! { |guess| guess.color == random_substitution.color }
        current_guess[position_to_substitute] = random_substitution
      end
    end

    current_guess
  end

  def initial_guess(possibilities)
    current_guess = Array.new(4)

    4.times do |n|
      possibility = possibilities.select { |pos| pos.position == n }.sample
      current_guess[possibility.position] = possibility
    end

    current_guess
  end

  def adjust_confidences(possibilities, last_guess, last_critique)
    # If there were no hits from the last critique, then they cannot possibly be included in the final code
    if last_critique.empty?
      impossible_colors = last_guess.map(&:color)
      possibilities = possibilities.map do |possibility|
        # This color is impossible if our last guess came back as empty
        possibility.make_impossible if impossible_colors.include?(possibility.color)
        possibility
      end
    end

    # If any of them were correct, then we know that all of those colors are wrong
    if last_critique.none?(:correct)
      possibilities = possibilities.map do |possibility|
        possibility.make_impossible if last_guess.include?(possibility)
        possibility
      end
    # If 3 of them were correct, then we're creally close
    elsif last_critique.count(:correct) == 3
      possibilities = possibilities.map do |possibility|
        possibility.greatly_increase_confidence if last_guess.include?(possibility)
        possibility
      end
    else
      possibilities = possibilities.map do |possibility|
        possibility.slightly_increase_confidence if last_guess.include?(possibility)
        possibility
      end
    end

    # If any of them were misplaced, then increase the confidence of those colors in all of the other positions
    if last_critique.include?(:misplaced)
      possibilities = possibilities.map do |possibility|
        last_guess.each do |guess|
          if guess.color == possibility.color && guess.position != possibility.position
            possibility.slightly_increase_confidence
          end
        end
        possibility
      end
    end

    possibilities
  end

  def generate_possibilities
    possibilities = []
    COLORS.each do |c|
      4.times do |n|
        possibility = Possibility.new(c, n)
        possibilities << possibility
      end
    end

    possibilities
  end
end

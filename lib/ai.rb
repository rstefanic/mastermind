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
      next if possibility.impossible?

      current_guess[possibility.position] = possibility if current_guess[possibility.position].nil?
    end

    # We never want to submit the same guess, so randomly change it
    while previous_guesses.include?(current_guess)
      random_substitution = possibilities.sample
      current_guess[random_substitution.position] = random_substitution
    end

    puts current_guess
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
      adjusted_possibilities = possibilities.map do |possibility|
        possibility.make_impossible if last_guess.include?(possibility)

        possibility
      end
    # If any of them were correct, then depending on how many there were, we can greatly increase our confidence
    elsif last_critique.include?(:correct)
      lowest_possibility = last_guess.min_by(&:confidence)
      if last_critique.count(:correct) == 3
        adjusted_possibilities = possibilities.map do |possibility|
          possibility.greatly_increase_confidence if last_guess.include?(possibility)
          possibility.decrease_possibility if possibility == lowest_possibility
          possibility
        end
      else
        adjusted_possibilities = possibilities.map do |possibility|
          possibility.slightly_increase_confidence if last_guess.include?(possibility)
          possibility.decrease_possibility if possibility == lowest_possibility
          possibility
        end
      end
    elsif last_critique.include?(:misplaced)
      lowest_possibility = last_guess.min_by(&:confidence)
      adjusted_possibilities = possibilities.map do |possibility|
        possibility.slightly_increase_confidence if last_guess.include?(possibility)
        possibility.decrease_possibility if possibility == lowest_possibility
        possibility
      end
    end

    adjusted_possibilities
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

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

    puts possible_colors
    possible_colors.each do |possibility|
      next if possibility.impossible?

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


    tries = 0
    # We never want to submit the same guess, so swap our least confidence guess
    while previous_guesses.include?(current_guess)

      lowest_possibility = current_guess.min_by(&:confidence)
      position_to_substitute = lowest_possibility.position

      if tries > 4
        position_to_substitute = (position_to_substitute + tries) % 4
      end

      next_best_guesses = possibilities.select do |p|
        p.position == position_to_substitute
      end

      random_substitution = next_best_guesses.sample
      current_guess[position_to_substitute] = random_substitution
      tries += 1
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
      adjusted_possibilities = possibilities.map do |possibility|
        # This color is impossible if our last guess came back as empty
        possibility.make_impossible if impossible_colors.include?(possibility.color)
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
        last_guess.each do |guess|
          possibility.slightly_increase_confidence if guess.color == possibility.color && guess.position != possibility.position
        end
        #possibility.decrease_possibility if possibility == lowest_possibility
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

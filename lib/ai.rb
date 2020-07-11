# frozen_string_literal: true

require './lib/color_confidence.rb'
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

  def order_colors_by_confidence(colors)
    colors.sort_by(&:confidence).reverse
  end

  def color_confidence_to_color(colors)
    raise 'Invalid color length' unless colors.length == 4

    colors.map(&:color)
  end

  def build_guess_with_confident_colors(color_confidences)
    current_guess = Array.new(4, nil)

    color_confidences.each do |cc|
      # only add the color if there's no color in that position for our guess
      # and we have a bit of confidence in it
      current_guess[cc.position] = cc if current_guess[cc.position].nil? && cc.confidence.positive?
    end

    current_guess
  end

  # Reminder: Return is only used for methods in Ruby!
  def build_guess_with_unconfident_colors(color_confidences, guess)
    guess.map do |g|
      if g.nil?
        new_g = nil
        color_confidences.each do |cc|
          # This will also break out of the each
          unless guess.reject(&:nil?).include?(cc) && cc.confidence.positive?
            new_g = cc
            break
          end
        end

        new_g
      else
        g
      end
   end
  end

  def evaluate_critique(critiques, guesses)
    last_critique = critiques.last
    last_guess = guesses.last

    # there there was nothing in our critique,
    # then return everything from the last guess with -1
    # we know that NONE of those colors appear anywhere
    if last_critique.empty?
      return last_guess.map do |guess|
        guess.confidence = 0
        guess
      end
    end


  end
end
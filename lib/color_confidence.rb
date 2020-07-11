# Used by the Computer to associate a color with a confidence value
# frozen_string_literal: true

require './lib/colors.rb'

# ColorConfidence
class ColorConfidence
  # Ties a confidence level to a color and its position
  attr_reader :color, :position, :confidence

  def initialize(color, position, confidence)
    @color = color
    @position = position
    @confidence = confidence
  end

  def ==(other)
    @color == other.color &&
      @position == other.position &&
      @confidence == other.confidence
  end
end

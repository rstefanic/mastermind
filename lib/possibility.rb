require './lib/colors.rb'

class Possibility
  include Colors
  attr_reader :color, :confidence, :position, :impossible
  HIGH = 75
  LOW = 25
  IMPROBABLE = 0

  def initialize(color, position)
    @color = color
    @position = position
    @confidence = LOW
    @impossible = false
  end

  def very_unlikely?
    @confidence <= IMPROBABLE || @impossible
  end

  def make_impossible
    @impossible = true
  end

  # We want to check if it's been marked as impossible before increasing the confidence
  # so that we're not increasing the confidence on colors that we know are impossible
  def slightly_increase_confidence
    @confidence += LOW unless impossible
  end

  def greatly_increase_confidence
    @confidence += HIGH unless impossible
  end

  def decrease_possibility
    @confidence -= LOW unless impossible
  end

  def ==(other)
    @color == other.color &&
      @position == other.position &&
      @confidence == other.confidence
  end

  def to_s
    "#{color_string(@color)} [#{position}:#{impossible ? 'IMPOSSIBLE' : confidence}] "
  end
end
require './lib/colors.rb'

class Possibility
  include Colors
  attr_reader :color, :confidence, :position
  HIGH = 75
  NEUTRAL = 50
  LOW = 25
  IMPOSSIBLE = 0

  def initialize(color, position)
    @color = color
    @position = position
    @confidence = LOW
  end

  def impossible?
    @confidnece == IMPOSSIBLE
  end

  def make_impossible
    @confidence = IMPOSSIBLE
  end

  def slightly_increase_confidence
    @confidence += 10
  end

  def greatly_increase_confidence
    @confidence += LOW
  end

  def decrease_possibility
    @confidence -= LOW
  end

  def ==(other)
    @color == other.color &&
      @position == other.position &&
      @confidence == other.confidence
  end

  def to_s
    "#{color_string(@color)} [#{position}:#{confidence}]"
  end
end
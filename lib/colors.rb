module Colors
  COLORS = [:black, :red, :blue, :orange, :green, :yellow, :purple]
  BLANK = :blank
  SPACING = 10

  def color_string(color)
    case color
    when :black then "Black".center(SPACING)
    when :red then "Red".center(SPACING)
    when :blue then "Blue".center(SPACING)
    when :orange then "Orange".center(SPACING)
    when :green then "Green".center(SPACING)
    when :yellow then "Yellow".center(SPACING)
    when :purple then "Purple".center(SPACING)
    else "".center(SPACING)
    end
  end

  def print_color_choices
    puts "Select a number 1 - #{COLORS.length} for a color. Color choices: "
    COLORS.each_with_index do |color, index|
      puts "{ #{index + 1}: #{color_string color} }"
    end

    print "\n"
  end

  def valid_choice?(input)
    input >= 0 && input < COLORS.length
  end
end
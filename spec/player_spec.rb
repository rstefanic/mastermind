require './lib/player'

describe Computer do
  describe '#generate_random_colors' do
    it 'should generate randomized colors with an array size of 4' do
      c = Computer.new
      expect(c.generate_random_colors.count).to eq(4)
    end

    it 'should not have any blanks in the array' do
      c = Computer.new
      expect(c.generate_random_colors.none?(:blank)).to be true
    end
  end

  describe '#order_colors_by_confidence' do
    it 'should correctly order the colors by their confidence level' do
      p = Computer.new

      colors = [
        ColorConfidence.new(:black, 0, 50),
        ColorConfidence.new(:red, 1, 25),
        ColorConfidence.new(:purple, 0, 75)
      ]

      sorted_colors = [
        ColorConfidence.new(:purple, 0, 75),
        ColorConfidence.new(:black, 0, 50),
        ColorConfidence.new(:red, 1, 25)
      ]

      expect(p.order_colors_by_confidence(colors)).to match_array(sorted_colors)
    end
  end

  describe '#color_confidence_to_color' do
    it 'should take a list of ColorConfidences and map them to just their colors' do
      p = Computer.new

      color_confidences = [
        ColorConfidence.new(:black, 0, 50),
        ColorConfidence.new(:red, 1, 25),
        ColorConfidence.new(:purple, 2, 75),
        ColorConfidence.new(:yellow, 3, 75)
      ]

      result = %i[black red purple yellow]
      expect(p.color_confidence_to_color(color_confidences)).to eql(result)
    end
  end

  describe '#build_guess_with_confident_colors' do
    c = Computer.new

    it 'should should take an array of ColorConfidences and assign them correctly' do
      color_confidences = [
        ColorConfidence.new(:yellow, 3, 75),
        ColorConfidence.new(:purple, 2, 75),
        ColorConfidence.new(:black, 0, 50),
        ColorConfidence.new(:red, 1, 25)
      ]

      result = [
        ColorConfidence.new(:black, 0, 50),
        ColorConfidence.new(:red, 1, 25),
        ColorConfidence.new(:purple, 2, 75),
        ColorConfidence.new(:yellow, 3, 75)
      ]

      expect(c.build_guess_with_confident_colors(color_confidences)).to match_array(result)
    end

    it 'should still build a guess with only one ColorConfidence' do
      color_confidences = [ColorConfidence.new(:red, 3, 100)]
      result = [nil, nil, nil, ColorConfidence.new(:red, 3, 100)]
      expect(result.reject(&:nil?).length).to eql(1)
      expect(c.build_guess_with_confident_colors(color_confidences)).to match_array(result)
    end
  end

  describe '#build_guess_with_unconfident_colors' do
    c = Computer.new

    it 'should take some less confident colors, and fill them in' do
      color_confidences = [
        ColorConfidence.new(:yellow, 2, 75),
        ColorConfidence.new(:purple, 2, 75),
        ColorConfidence.new(:black, 0, 50),
        ColorConfidence.new(:red, 1, 25)
      ]

      current_guess = c.build_guess_with_confident_colors(color_confidences)

      result = [
        ColorConfidence.new(:black, 0, 50),
        ColorConfidence.new(:red, 1, 25),
        ColorConfidence.new(:yellow, 2, 75),
        ColorConfidence.new(:purple, 2, 75)
      ]

      expect(current_guess).to be_a Array
      expect(result).to be_a Array
      expect(c.build_guess_with_unconfident_colors(color_confidences, current_guess)).to match_array(result)
    end
  end
end

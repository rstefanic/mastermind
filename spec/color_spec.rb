require './lib/player'

describe Colors do
  p = Player.new

  describe '#color_string' do
    it 'should return "Black" when passed the :black symbol' do
      expect(p.color_string(:black)).to eql('Black'.center(Colors::SPACING))
    end

    it 'should return "" when passed the :blank symbol' do
      expect(p.color_string(:blank)).to eql(''.center(Colors::SPACING))
    end
  end

  describe '#valid_choice?' do
    it 'should return true as long as the value is within the bounds of the color array' do
      expect(p.valid_choice?(rand(Colors::COLORS.size))).to be true
    end

    it 'should return false of any value outside of the bounds of the color array' do
      expect(p.valid_choice?(Colors::COLORS.size + 1)).to be false
    end
  end
end

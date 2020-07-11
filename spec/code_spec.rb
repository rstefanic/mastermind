require './lib/player'

describe Code do
  p = Player.new

  describe '#critique_code' do
    it 'should critique the guess correctly' do
      code = %i[black red green purple]
      guess = %i[black green green red]
      result = %i[correct correct misplaced]
      expect(p.critique_code(code, guess)).to eql(result)
    end

    it 'should critique the guess with the code having two of the same color' do
      code = %i[black black yellow blue]
      guess = %i[black green black red]
      result = %i[correct misplaced]
      expect(p.critique_code(code, guess)).to eql(result)
    end

    it 'should critique a complex guess correctly (1)' do
      code = %i[red orange yellow green]
      guess = %i[purple orange blue yellow]
      result = %i[correct misplaced]
      expect(p.critique_code(code, guess)).to eql(result)
    end

    it 'should critique a complex guess correctly (2)' do
      code = %i[red orange yellow green]
      guess = %i[blue orange black purple]
      result = %i[correct]
      expect(p.critique_code(code, guess)).to eql(result)
    end
  end

  describe '#critique_to_strings' do
    it 'should take a critique and correctly change the symbols strings' do
      p = Player.new
      critique = %i[correct correct misplaced]
      result = %w[Correct Correct Misplaced]

      expect(p.critique_to_strings(critique)).to eql(result)
    end
  end

  describe '#guess_correct?' do
    it 'should say the guess is correct when the guess matches the code' do
      code = %i[black red green purple]
      guess = %i[black red green purple]
      expect(p.guess_correct?(code, guess)).to be true
    end

    it 'should say the guess is incorrect when the guess does not match the code' do
      code = %i[black red green purple]
      guess = %i[red green blue yellow]
      expect(p.guess_correct?(code, guess)).to be false
    end
  end
end
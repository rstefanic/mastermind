# frozen_string_literal: true

# Code has all of the parts that do with handling the code
module Code
  def print_code(code)
    raise 'Invalid Code' if code.length != 4

    "[#{color_string code[0]} | #{color_string code[1]} | #{color_string code[2]} | #{color_string code[3]} ]"
  end

  def critique_code(code, guess)
    critique = []
    code_without_correct_guesses = []

    # Mark the correct guesses
    i = 0
    while i < code.size
      if code[i] == guess[i]
        critique << :correct
        guess[i] = nil
      else
        code_without_correct_guesses << code[i]
      end

      i += 1
    end

    # Remove the nils that were generated from removing the correct guesses
    guess -= [nil]

    # Mark the misplaced gusses
    code_without_correct_guesses.each do |current_code|
      index = guess.find_index(current_code)
      unless index.nil?
        guess.delete_at(index)
        critique << :misplaced
      end
    end

    critique
  end

  def critique_to_strings(critique)
    critique.map do |c|
      if c == :correct
        'Correct'
      else
        'Misplaced'
      end
    end
  end

  def guess_correct?(code, guess)
    raise 'Invalid guess' if guess.length != 4
    raise 'Invalid code' if code.length != 4

    # Here we have to roll our own checking because @code.difference(guess).any?
    # will say that there isn't a difference as long as they just have the same
    # elements (that method doesn't care about the order at all, but we do)
    code[0] == guess[0] && code[1] == guess[1] && code[2] == guess[2] && code[3] == guess[3]
  end
end

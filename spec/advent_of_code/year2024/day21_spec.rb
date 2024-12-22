# frozen_string_literal: true

RSpec.describe AdventOfCode::Year2024::Day21 do
  describe "Solver" do
    subject(:solver) { described_class::Solver.new(keypad) }

    let(:keypad) { Keypad.from_raw(raw_keypad) }

    let(:raw_keypad) do
      <<~TXT.chomp
        789
        456
        123
        .0A
      TXT
    end

    # N.B. this implicitly starts at A.
    let(:buttons) { ["1", "7", "6", "8"] }

    it "generates a valid activation sequence" do
      expect(solver.activation_sequence(buttons)).to eq("^<<A^^Av>>A<^A")
    end
  end

  context "solves the calibration problem for part 1" do
    subject(:solution) { described_class.new(raw_problem).solution_part1 }

    let(:raw_problem) do
      <<~TXT.chomp
        029A
        980A
        179A
        456A
        379A
      TXT
    end

    it "matches the expected solution" do
      expect(solution).to eq(126384)
    end
  end
end

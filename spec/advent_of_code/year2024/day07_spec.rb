# frozen_string_literal: true

RSpec.describe AdventOfCode::Year2024::Day07 do
  describe "Equation" do
    subject { described_class::Equation.from_string(string) }

    let(:string) { "100: 1 2 3" }

    its(:solution) { is_expected.to eq(100) }
    its(:values) { is_expected.to eq([1, 2, 3]) }
  end

  describe "Permuter" do
    subject { described_class::Permuter.new(equation) }

    context "for an implausible equation" do
      let(:equation) { described_class::Equation.new(100, [2, 3, 4]) }

      its(:plausible?) { is_expected.to eq(false) }
    end

    context "for a plausible equation" do
      let(:equation) { described_class::Equation.new(10, [2, 3, 4]) }

      its(:plausible?) { is_expected.to eq(true) }
    end

    # Solution for "9 * 566 + 32 + 964 * 9 * 815 + 60".
    context "for a complex plausible equation" do
      let(:equation) do
        described_class::Equation.new(44670210, [9, 566, 32, 964, 9, 815, 60])
      end

      its(:plausible?) { is_expected.to eq(true) }
    end
  end

  context "for the calibration problem for part 1" do
    subject { described_class.new(problem).solution_part1 }

    let(:problem) do
      <<~TXT
        190: 10 19
        3267: 81 40 27
        83: 17 5
        156: 15 6
        7290: 6 8 6 15
        161011: 16 10 13
        192: 17 8 14
        21037: 9 7 18 13
        292: 11 6 16 20
      TXT
    end

    let(:solution) { 3749 }

    it { is_expected.to eq(solution) }
  end

  context "for the calibration problem for part 2" do
    subject { described_class.new(problem).solution_part2 }

    let(:problem) do
      <<~TXT
        190: 10 19
        3267: 81 40 27
        83: 17 5
        156: 15 6
        7290: 6 8 6 15
        161011: 16 10 13
        192: 17 8 14
        21037: 9 7 18 13
        292: 11 6 16 20
      TXT
    end

    let(:solution) { 11387 }

    it { is_expected.to eq(solution) }
  end
end

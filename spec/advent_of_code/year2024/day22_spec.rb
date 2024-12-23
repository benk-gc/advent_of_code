# frozen_string_literal: true

RSpec.describe AdventOfCode::Year2024::Day22 do
  describe "SecretNumberFinder" do
    subject(:finder) do
      described_class::SecretNumberFinder.new(start)
    end

    let(:start) { 123 }

    shared_examples "finds the secret number" do |iterations:, result:|
      it "#{iterations} iterations" do
        expect(finder.find(iterations)).to eq(result)
      end
    end

    it_behaves_like "finds the secret number", iterations: 1, result: 15887950
    it_behaves_like "finds the secret number", iterations: 2, result: 16495136
    it_behaves_like "finds the secret number", iterations: 3, result: 527345
    it_behaves_like "finds the secret number", iterations: 4, result: 704524
    it_behaves_like "finds the secret number", iterations: 5, result: 1553684
    it_behaves_like "finds the secret number", iterations: 6, result: 12683156
    it_behaves_like "finds the secret number", iterations: 7, result: 11100544
    it_behaves_like "finds the secret number", iterations: 8, result: 12249484
    it_behaves_like "finds the secret number", iterations: 9, result: 7753432
    it_behaves_like "finds the secret number", iterations: 10, result: 5908254

    it "finds the correct prices" do
      expect(finder.prices(10)).to eq([3, 0, 6, 5, 4, 4, 6, 4, 4, 2])
    end

    it "finds the correct changes" do
      expect(finder.changes(finder.prices(10))).to eq([3, -3, 6, -1, -1, 0, 2, -2, 0, -2])
    end
  end

  describe "SequenceMixer" do
    subject(:mixer) { described_class::SequenceMixer.new(changes, prices) }

    let(:changes) { [1, -1, 1, -1, 1, -1] }
    let(:prices) { [1, 2, 0, 1, 5, 10] }

    let(:expected_sequences) do
      [
        having_attributes(sequence: [1, -1, 1, -1], price: 1),
        having_attributes(sequence: [-1, 1, -1, 1], price: 5),
      ]
    end

    describe "#change_sequences" do
      it "detects the correct sequences" do
        expect(mixer.change_sequences).to match(expected_sequences)
      end
    end

    describe ".mix" do
      subject(:mix) { described_class::SequenceMixer.mix(change_sequences) }

      let(:change_sequences) do
        [
          described_class::ChangeSequence.new(sequence: [-1, 2, -3, 4], price: 10),
          described_class::ChangeSequence.new(sequence: [-3, 2, -3, 4], price: 1),
          described_class::ChangeSequence.new(sequence: [-3, 2, -3, 4], price: 9),
          described_class::ChangeSequence.new(sequence: [-1, 2, -3, 4], price: 5),
        ]
      end

      it "returns the correct sequence" do
        expect(mix).to eq(15)
      end
    end
  end

  context "solves the calibration problem for part 1" do
    subject(:solution) { described_class.new(raw_problem).solution_part1 }

    let(:raw_problem) do
      <<~TXT.chomp
        1
        10
        100
        2024
      TXT
    end

    it "matches the given solution" do
      expect(solution).to eq(37327623)
    end
  end

  context "solves the calibration problem for part 2" do
    subject(:solution) { described_class.new(raw_problem).solution_part2 }

    let(:raw_problem) do
      <<~TXT.chomp
        1
        2
        3
        2024
      TXT
    end

    it "matches the given solution" do
      expect(solution).to eq(23)
    end
  end
end

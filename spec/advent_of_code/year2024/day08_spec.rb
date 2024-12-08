# frozen_string_literal: true

RSpec.describe AdventOfCode::Year2024::Day08 do
  describe "NodeGroup" do
    subject { described_class::NodeGroup.new(nodes) }

    # Our matrix and solution:
    #
    #   N * * *
    #   * P * *
    #   * * P *
    #   * * * N
    let(:nodes) do
      [[1, 1], [2, 2]].shuffle
    end

    its(:resonance_points) { is_expected.to contain_exactly([0, 0], [3, 3]) }
  end

  describe "StringMatrix" do
    subject(:matrix) { described_class::StringMatrix.new(rows) }

    let(:rows) do
      [
        ["A", "B", "C"],
        ["D", "E", "F"],
      ]
    end

    describe "#elements" do
      let(:expected_elements) do
        [
          ["A", [0, 0]],
          ["B", [1, 0]],
          ["C", [2, 0]],
          ["D", [0, 1]],
          ["E", [1, 1]],
          ["F", [2, 1]],
        ]
      end

      it "returns the expected elements" do
        expect(matrix.elements.to_a).to eq(expected_elements)
      end
    end
  end

  context "solves the calibration problem for part 1" do
    subject { described_class.new(problem).solution_part1 }

    let(:problem) do
      <<~TXT
        ............
        ........0...
        .....0......
        .......0....
        ....0.......
        ......A.....
        ............
        ............
        ........A...
        .........A..
        ............
        ............
      TXT
    end

    it { is_expected.to eq(14) }
  end
end

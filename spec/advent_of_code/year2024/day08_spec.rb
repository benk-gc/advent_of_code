# frozen_string_literal: true

RSpec.describe AdventOfCode::Year2024::Day08 do
  describe "CoordGroup" do
    subject(:group) { described_class::CoordGroup.new(coords) }

    describe "#resonance_points" do
      # Our matrix and solution:
      #
      #   N * * *
      #   * P * *
      #   * * P *
      #   * * * N
      let(:coords) do
        [Coord.new(1, 1), Coord.new(2, 2)].shuffle
      end

      let(:resonance_points) do
        [Coord.new(0, 0), Coord.new(3, 3)]
      end

      its(:resonance_points) { is_expected.to match_array(resonance_points) }
    end

    describe "#all_resonance_points_within" do
      # Our matrix and solution:
      #
      #   N * * * *
      #   * P * * *
      #   * * P * *
      #   * * * N *
      #   * * * * N
      let(:coords) do
        [Coord.new(1, 1), Coord.new(2, 2)].shuffle
      end

      let(:resonance_points) do
        (0..4).map { |i| Coord.new(i, i) }
      end

      let(:limit) { Coord.new(4, 4) }

      it "returns the expected resonance points" do
        expect(group.all_resonance_points_within(limit)).
          to match_array(resonance_points)
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

  context "solves the calibration problem for part 2" do
    subject { described_class.new(problem).solution_part2 }

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

    it { is_expected.to eq(34) }
  end
end

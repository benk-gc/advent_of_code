# frozen_string_literal: true

RSpec.describe AdventOfCode::Year2024::Day06 do
  let(:map) do
    <<~MAP.chomp
      ....#.....
      .........#
      ..........
      ..#.......
      .......#..
      ..........
      .#..^.....
      ........#.
      #.........
      ......#...
    MAP
  end

  describe described_class::Map do
    subject(:map) { described_class.from_raw(raw_map) }

    let(:raw_map) do
      <<~MAP.chomp
        #..
        ...
        #.^
      MAP
    end

    it "removes the guard" do
      expect(map.element(2, 2)).to eq(".")
    end

    it "maps the remaining elements correctly" do
      expect(map.element(0, 0)).to eq("#")
      expect(map.element(0, 1)).to eq(".")
    end
  end

  describe described_class::Guard do
    subject(:guard) { described_class.from_raw(raw_map) }

    let(:raw_map) do
      <<~MAP.chomp
        #.#
        ...
        ...
        #.^
      MAP
    end

    it "finds the guard's current position" do
      expect(guard.current_position).to eq([2, 3])
    end

    it "calculates the guard's next position" do
      expect(guard.next_position).to eq([2, 2])
    end

    it "maps a series of movements" do
      coords = [:move!, :move!, :turn!, :move!].map do |instruction|
        guard.send(instruction)
        guard.current_position
      end

      expect(coords).to eq([[2, 2], [2, 1], [2, 1], [3, 1]])
    end
  end

  describe described_class::StringMatrix do
    subject(:matrix) { described_class.new(rows) }

    let(:rows) do
      [["A", "B"], ["C", "D"], ["E", "F"]]
    end

    it "returns the correct elements by co-ordinate" do
      expect(matrix.element(0, 0)).to eq("A")
      expect(matrix.element(1, 0)).to eq("B")
      expect(matrix.element(0, 1)).to eq("C")
      expect(matrix.element(1, 1)).to eq("D")
      expect(matrix.element(0, 2)).to eq("E")
      expect(matrix.element(1, 2)).to eq("F")
    end

    it "has the correct bounds" do
      expect(matrix).to have_attributes(x_max: 1, y_max: 2)
    end

    it "raises an error when we access elements out of bounds" do
      expect { matrix.element(-1, -1) }.to raise_error(described_class::OutOfBoundsError)
      expect { matrix.element(2, 3) }.to raise_error(described_class::OutOfBoundsError)
    end
  end

  describe "#solution" do
    subject(:solution) { described_class.new(sample_problem).solution }

    let(:sample_problem) do
      <<~MAP.chomp
        ....#.....
        .........#
        ..........
        ..#.......
        .......#..
        ..........
        .#..^.....
        ........#.
        #.........
        ......#...
      MAP
    end

    it "calculates the correct number of tiles" do
      expect(solution).to eq(41)
    end
  end
end

# frozen_string_literal: true

RSpec.describe AdventOfCode::Year2024::Day15 do
  describe "Scenario" do
    subject(:scenario) { described_class::Scenario.from_raw(raw_problem) }

    let(:raw_problem) do
      <<~TXT.chomp
        ########
        #..O.O.#
        ##@.O..#
        #...O..#
        #.#.O..#
        #...O..#
        #......#
        ########

        <^^>>>vv<v>>v<<
      TXT
    end

    let(:expected_movements) do
      [
        :left, :up, :up, :right, :right, :right, :down, :down, :left, :down,
        :right, :right, :down, :left, :left
      ]
    end

    let(:expected_map) do
      <<~TXT.chomp
        ########
        #..O.O.#
        ##..O..#
        #...O..#
        #.#.O..#
        #...O..#
        #......#
        ########
      TXT
    end

    let(:simulated_map) do
      <<~TXT.chomp
        ########
        #....OO#
        ##.....#
        #.....O#
        #.#O...#
        #...O..#
        #...O..#
        ########
      TXT
    end

    it "parses the movements correctly" do
      expect(scenario.movements).to eq(expected_movements)
    end

    it "parses the map correctly" do
      expect(scenario.map.draw).to eq(expected_map)
    end

    it "parses the robot correctly" do
      expect(scenario.robot.current_position).to have_attributes(x: 2, y: 2)
    end

    it "simulates the problem correctly" do
      expect { scenario.simulate! }.to change { scenario.map.draw }.to eq(simulated_map)
      expect(scenario.robot.current_position).to have_attributes(x: 4, y: 4)
    end
  end

  context "solves the calibration problem for part 1" do
    subject(:scenario) { described_class::Scenario.from_raw(raw_problem) }

    let(:raw_problem) do
      <<~TXT.chomp
        ##########
        #..O..O.O#
        #......O.#
        #.OO..O.O#
        #..O@..O.#
        #O#..O...#
        #O..O..O.#
        #.OO.O.OO#
        #....O...#
        ##########

        <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
        vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
        ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
        <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
        ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
        ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
        >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
        <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
        ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
        v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
      TXT
    end

    it "solves the problem correct" do
      expect(scenario.solve!).to eq(10092)
    end
  end
end

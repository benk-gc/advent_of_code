# frozen_string_literal: true

RSpec.describe AdventOfCode::Year2024::Day14 do
  describe "ActorParser" do
    subject(:actors) { described_class::ActorParser.from_raw(raw_actors) }

    let(:raw_actors) do
      <<~TXT.chomp
        p=0,4 v=3,-3
        p=6,3 v=-1,-3
      TXT
    end

    it "parses the actors correctly" do
      expect(actors).to contain_exactly(
        have_attributes(
          current_position: have_attributes(x: 0, y: 4),
          movement_vector: have_attributes(x: 3, y: -3),
        ),
        have_attributes(
          current_position: have_attributes(x: 6, y: 3),
          movement_vector: have_attributes(x: -1, y: -3),
        ),
      )
    end
  end

  context "solves the calibration problem for part 1" do
    subject(:solution) { problem.solve(ticks) }

    let(:ticks) { 100 }
    let(:problem) { described_class::Scenario.new(map, actors) }
    let(:map) { Map.new(Array.new(7, Array.new(11, "."))) }
    let(:actors) { described_class::ActorParser.from_raw(raw_actors) }

    let(:raw_actors) do
      <<~TXT.chomp
        p=0,4 v=3,-3
        p=6,3 v=-1,-3
        p=10,3 v=-1,2
        p=2,0 v=2,-1
        p=0,0 v=1,3
        p=3,0 v=-2,-2
        p=7,6 v=-1,-3
        p=3,0 v=-1,-2
        p=9,3 v=2,3
        p=7,3 v=-1,2
        p=2,4 v=2,-3
        p=9,5 v=-3,-3
      TXT
    end

    it "produces the correct checksum" do
      expect(solution).to eq(12)
    end
  end
end

# frozen_string_literal: true

RSpec.describe Actor do
  subject(:actor) { described_class.new(current_coord, movement_vector) }

  let(:current_coord) { Coord.new(1, 2) }

  describe "#next_position" do
    subject(:next_position) { actor.next_position }

    context "with a positive movement vector" do
      let(:movement_vector) { Coord.new(3, 1) }

      it { is_expected.to have_attributes(x: 4, y: 3) }
    end

    context "with a negative movement vector" do
      let(:movement_vector) { Coord.new(-3, -1) }

      it { is_expected.to have_attributes(x: -2, y: 1) }
    end
  end

  describe "next_position_wraparound" do
    subject(:next_position_wraparound) { actor.next_position_wraparound(map) }

    let(:map) do
      Map.from_raw(
        <<~MAP.chomp,
          ....
          ....
          ....
          ....
        MAP
      )
    end

    context "with a positive movement vector" do
      let(:movement_vector) { Coord.new(1, 1) }

      it { is_expected.to have_attributes(x: 2, y: 3) }
    end

    context "with a positive movement vector with wraparound" do
      let(:movement_vector) { Coord.new(4, 6) }

      it { is_expected.to have_attributes(x: 1, y: 0) }
    end

    context "with a negative movement vector with wraparound" do
      let(:movement_vector) { Coord.new(-3, -1) }

      it { is_expected.to have_attributes(x: 2, y: 1) }
    end
  end
end

# frozen_string_literal: true

RSpec.describe Keypad do
  subject(:keypad) { described_class.from_raw(raw_keypad) }

  let(:raw_keypad) do
    <<~TXT
      AB
      CD
    TXT
  end

  context "a keypad with a single space" do
    let(:raw_keypad) do
      <<~TXT
        ABC
        .DE
      TXT
    end

    it "is expected to not raise an error" do
      expect { keypad }.to_not raise_error
    end
  end

  context "a keypad with a multiple spaces" do
    let(:raw_keypad) do
      <<~TXT
        AB.
        .CD
      TXT
    end

    it "raises an error" do
      expect { keypad }.to raise_error("This keypad doesn't have unique buttons")
    end
  end

  describe "#buttons" do
    let(:expected_buttons) do
      {
        "A" => having_attributes(x: 0, y: 0),
        "B" => having_attributes(x: 1, y: 0),
        "C" => having_attributes(x: 0, y: 1),
        "D" => having_attributes(x: 1, y: 1),
      }
    end

    it "has the expected buttons" do
      expect(keypad.buttons).to match(expected_buttons)
    end
  end

  describe "#position" do
    it "retrieves the correct position for a button" do
      expect(keypad.position("C")).to have_attributes(x: 0, y: 1)
    end
  end

  describe "#decompose" do
    context "for a positive movement" do
      let(:expected_decomposition) do
        [
          [having_attributes(x: 0, y: 1), having_attributes(x: 1, y: 0)],
          [having_attributes(x: 1, y: 0), having_attributes(x: 0, y: 1)],
        ]
      end

      it "decomposes the movement correctly" do
        expect(keypad.decompose(Coord.new(1, 1))).to match_array(expected_decomposition)
      end
    end

    context "for a mixed movement" do
      let(:expected_decomposition) do
        [
          [having_attributes(x: 0, y: 1), having_attributes(x: -1, y: 0)],
          [having_attributes(x: -1, y: 0), having_attributes(x: 0, y: 1)],
        ]
      end

      it "decomposes the movement correctly" do
        expect(keypad.decompose(Coord.new(-1, 1))).to match_array(expected_decomposition)
      end
    end
  end

  describe "#navigate" do
    context "for a positive movement" do
      let(:from_coord) { Coord.new(0, 0) }
      let(:to_coord) { Coord.new(1, 1) }

      let(:expected_navigation) do
        [having_attributes(x: 1, y: 0), having_attributes(x: 0, y: 1)]
      end

      it "navigates the movement correctly" do
        expect(keypad.navigate(from_coord: from_coord, to_coord: to_coord)).
          to match_array(expected_navigation)
      end
    end

    context "for a mixed movement" do
      let(:from_coord) { Coord.new(1, 0) }
      let(:to_coord) { Coord.new(0, 1) }

      let(:expected_navigation) do
        [having_attributes(x: -1, y: 0), having_attributes(x: 0, y: 1)]
      end

      it "navigates the movement correctly" do
        expect(keypad.navigate(from_coord: from_coord, to_coord: to_coord)).
          to match_array(expected_navigation)
      end
    end
  end
end

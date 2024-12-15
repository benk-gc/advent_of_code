# frozen_string_literal: true

RSpec.describe StringMatrix do
  subject(:matrix) { described_class.new(rows) }

  let(:rows) do
    [
      ["A", "B", "C"],
      ["D", "E", "F"],
    ]
  end

  describe "#elements" do
    let(:expected_elements) do
      [
        ["A", Coord.new(0, 0)],
        ["B", Coord.new(1, 0)],
        ["C", Coord.new(2, 0)],
        ["D", Coord.new(0, 1)],
        ["E", Coord.new(1, 1)],
        ["F", Coord.new(2, 1)],
      ]
    end

    it "returns the expected elements" do
      expect(matrix.elements.to_a).to eq(expected_elements)
    end
  end

  describe "#draw" do
    let(:expected_draw) do
      <<~TXT.chomp
        ABC
        DEF
      TXT
    end

    it "draws the expected map" do
      expect(matrix.draw).to eq(expected_draw)
    end
  end

  describe "#write" do
    let(:coord) { Coord.new(1, 0) }

    it "changes the element" do
      expect { matrix.write("G", coord) }.
        to change { matrix.element(coord) }.
        from("B").to("G")
    end
  end

  describe "#vertical_symmetry" do
    context "for an unsymmetrical matrix" do
      let(:rows) do
        [
          [".", ".", ".", "x"],
          [".", ".", ".", "x"],
          [".", ".", ".", "x"],
          [".", ".", ".", "x"],
        ]
      end

      it "returns 0" do
        expect(matrix.vertical_symmetry(4, "x")).to eq(0.0)
      end
    end

    context "for a partially symmetrical matrix" do
      let(:rows) do
        [
          [".", ".", ".", "x"],
          ["x", ".", ".", "x"],
          ["x", ".", ".", "."],
          [".", ".", ".", "."],
        ]
      end

      it "returns 0.5" do
        expect(matrix.vertical_symmetry(4, "x")).to eq(0.5)
      end
    end

    context "for a completely symmetrical matrix" do
      let(:rows) do
        [
          [".", ".", ".", "."],
          ["x", ".", ".", "x"],
          ["x", ".", ".", "x"],
          [".", ".", ".", "."],
        ]
      end

      it "returns 1" do
        expect(matrix.vertical_symmetry(4, "x")).to eq(1.0)
      end
    end

    context "for a completely symmetrical matrix with a midline" do
      let(:rows) do
        [
          [".", ".", ".", ".", "."],
          ["x", ".", "x", ".", "x"],
          ["x", ".", "x", ".", "x"],
          [".", ".", ".", ".", "."],
        ]
      end

      it "returns 1" do
        expect(matrix.vertical_symmetry(6, "x")).to eq(1.0)
      end
    end
  end
end

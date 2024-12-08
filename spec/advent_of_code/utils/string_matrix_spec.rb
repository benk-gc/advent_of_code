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
end

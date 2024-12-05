# frozen_string_literal: true

RSpec.describe AdventOfCode::Year2024::Day05 do
  subject(:instance) { described_class.new(problem) }

  let(:problem) do
    <<~TXT.chomp
      12|99
      12|20
      50|33

      1,99,12
      1,2,3,4,5
      1,33,50
      6,7,8,9,10
    TXT
  end

  let(:parsed_constraints) do
    [[12, 99], [12, 20], [50, 33]]
  end

  let(:parsed_lines) do
    [[1, 99, 12], [1, 2, 3, 4, 5], [1, 33, 50], [6, 7, 8, 9, 10]]
  end

  it "parses the problem correctly" do
    expect(instance.problem).to have_attributes(
      constraints: match_array(parsed_constraints),
      lines: match_array(parsed_lines),
    )
  end

  it "parses the constraints correctly" do
    expect(instance.constraints).to have_attributes(
      befores: { 99 => Set[12], 20 => Set[12], 33 => Set[50] },
      afters: { 12 => Set[99, 20], 50 => Set[33] },
    )
  end

  it "iterates a line correctly" do
    line = described_class::Line[1, 2, 3]

    expect(line.each_with_before_after).to contain_exactly(
      [1, Set[], Set[2, 3]],
      [2, Set[1], Set[3]],
      [3, Set[1, 2], Set[]],
    )
  end

  it "returns the correct solution" do
    expect(instance.solution).to eq(11)
  end
end

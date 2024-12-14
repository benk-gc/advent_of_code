# frozen_string_literal: true

RSpec.describe AdventOfCode::Year2024::Day09 do
  describe "FileIndex" do
    subject(:file_index) { described_class::FileIndex.new(layout) }

    let(:raw_disk) { "1234511" }
    let(:disk) { described_class::Disk.from_string(raw_disk) }
    let(:layout) { disk.layout }

    let(:expected_index) do
      {
        1 => [
          having_attributes(index: 16, file: having_attributes(id: 3, size: 1)),
          having_attributes(index: 0, file: having_attributes(id: 0, size: 1)),
        ],
        3 => [
          having_attributes(index: 3, file: having_attributes(id: 1, size: 3)),
        ],
        5 => [
          having_attributes(index: 10, file: having_attributes(id: 2, size: 5)),
        ],
      }
    end

    it "builds a file index with the expected structure" do
      expect(file_index.index).to match(expected_index)
    end

    it "returns the expected file for min_index 1, max_size 1" do
      expect(file_index.find_file(min_index: 1, max_size: 1)).
        to match(having_attributes(index: 16, file: having_attributes(id: 3, size: 1)))
    end

    it "returns the expected file for min_index 2, max_size 4" do
      expect(file_index.find_file(min_index: 2, max_size: 4)).
        to match(having_attributes(index: 3, file: having_attributes(id: 1, size: 3)))
    end

    it "returns the expected file for min_index 17, max_size 4" do
      expect(file_index.find_file(min_index: 17, max_size: 1)).
        to be_nil
    end
  end

  describe "Disk" do
    subject(:disk) { described_class::Disk.from_string(raw_disk) }

    let(:raw_disk) { "12345" }
    let(:free) { described_class::DiskFile::FREE }

    let(:layout) do
      [
        having_attributes(id: 0),
        having_attributes(id: free),
        having_attributes(id: free),
        having_attributes(id: 1),
        having_attributes(id: 1),
        having_attributes(id: 1),
        having_attributes(id: free),
        having_attributes(id: free),
        having_attributes(id: free),
        having_attributes(id: free),
        having_attributes(id: 2),
        having_attributes(id: 2),
        having_attributes(id: 2),
        having_attributes(id: 2),
        having_attributes(id: 2),
      ]
    end

    its(:layout) { is_expected.to match(layout) }

    describe "#defrag" do
      let(:layout) do
        [
          having_attributes(id: 0),
          having_attributes(id: 2),
          having_attributes(id: 2),
          having_attributes(id: 1),
          having_attributes(id: 1),
          having_attributes(id: 1),
          having_attributes(id: 2),
          having_attributes(id: 2),
          having_attributes(id: 2),
          having_attributes(id: free),
          having_attributes(id: free),
          having_attributes(id: free),
          having_attributes(id: free),
          having_attributes(id: free),
          having_attributes(id: free),
        ]
      end

      it "defrags the disk correctly" do
        disk.defrag!
        expect(disk.layout).to match(layout)
      end
    end
  end

  context "solves the calibration problem for part 1" do
    subject(:disk) { described_class::Disk.from_string(problem) }

    let(:problem) { "2333133121414131402" }

    it "produces the correct checksum" do
      disk.defrag!

      expect(disk.checksum).to eq(1928)
    end
  end

  # context "solves the calibration problem for part 2" do
  #   subject(:disk) { described_class::Disk.from_string(problem) }
  #
  #   let(:problem) { "00...111...2...333.44.5555.6666.777.888899" }
  #   let(:solution) { "00992111777.44.333....5555.6666.....8888.." }
  #
  #   it "produces the correct checksum" do
  #     disk.contiguous_defrag!
  #
  #     expect(disk.checksum).to eq(2858)
  #   end
  #
  #   it "produces the correct layout" do
  #     disk.contiguous_defrag!
  #
  #     expect(disk.layout.map(&:id).join).to eq(solution)
  #   end
  # end
end

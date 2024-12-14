# frozen_string_literal: true

module AdventOfCode
  module Year2024
    class Day09
      class Disk
        def self.from_string(raw_disk)
          layout = raw_disk.chars.map(&:to_i).each_with_index.map do |value, index|
            if index.even?
              [DiskFile.new(index.to_i / 2, size: value)] * value
            else
              [DiskFile.free] * value
            end
          end.flatten

          new(layout)
        end

        attr_reader :layout

        def initialize(layout)
          @layout = layout
        end

        def checksum
          layout.
            each_with_index.
            filter_map { |file, index| file.id * index if file.data? }.
            sum
        end

        def defrag!
          last_file_index = nil
          file_count = layout.count(&:data?)

          (0..(file_count - 1)).each do |index|
            next unless layout[index].free?

            # Use a pointer to the last file to speed up searching.
            last_file_index = get_last_file(last_file_index)

            # Swap items in-place for extra cool points.
            layout[index], layout[last_file_index] = layout[last_file_index], layout[index]

            # Since we know this is now free space we can optimise.
            last_file_index -= 1
          end
        end

        def contiguous_defrag!
          index = 0
          file_index = FileIndex.new(layout)

          while index < layout.count
            index += 1 unless layout[index].free?

            contiguous_free_space = 1

            (index + 1..layout.count - 1).each do |j|
              if layout[index + j].free?
                contiguous_free_space += 1
              else
                break
              end
            end

            eligible_item = file_index.
              find_file(min_index: index + 1, max_size: contiguous_free_space)

            if eligible_item
              f_index = eligible_item.index
              size = eligible_item.file.size

              layout[index..(index + size - 1)], layout[f_index..(f_index + size - 1)] =
                layout[f_index..(f_index + size - 1)], layout[index..(index + size - 1)]

              eligible_item.index = index

              index += size
            else
              index += 1
            end
          end
        end

        def get_last_file(last_file_index)
          last_file_index = layout.count - 1 if last_file_index.nil?

          while last_file_index > -1
            return last_file_index if layout[last_file_index].data?

            last_file_index -= 1
          end

          raise "No files found to defrag!"
        end
      end

      class FileIndex
        IndexItem = Struct.new(:index, :file, keyword_init: true)

        attr_reader :layout, :index

        def initialize(layout)
          @layout = layout
          @index = build_file_index
        end

        def find_file(min_index:, max_size:)
          while max_size.positive?
            if index[max_size]
              eligible_file = index[max_size].find { |item| item.index > min_index }

              return eligible_file if eligible_file.present?
            end

            max_size -= 1
          end

          nil
        end

        private

        def build_file_index
          idx = 0

          # We want to store the files indexed by size and offset.
          file_index = Hash.new { [] }

          while idx < layout.size
            file = layout[idx]

            if file.data?
              # Inherently sort from highest to lowest id.
              file_index[file.size] = file_index[file.size].
                unshift(IndexItem.new(index: idx, file: file))
            end

            idx += file.size
          end

          file_index
        end
      end

      class DiskFile
        FREE = "."

        attr_reader :id, :size

        def self.free
          new(FREE)
        end

        def initialize(id, size: 1)
          @id = id
          @size = size
        end

        def free?
          id == FREE
        end

        def data?
          !free?
        end
      end

      def initialize(problem)
        @raw_problem = problem
      end

      def solution_part1
        disk.defrag!
        disk.checksum
      end

      def disk
        @disk ||= Disk.from_string(raw_problem)
      end

      private

      attr_reader :raw_problem
    end
  end
end

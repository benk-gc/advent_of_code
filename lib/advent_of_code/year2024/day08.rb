# frozen_string_literal: true

module AdventOfCode
  module Year2024
    class Day08
      class AntinodeFinder
        PYLONS = [*"a".."z", *"A".."Z", *"0".."9"].to_set

        attr_reader :map

        def initialize(map)
          @map = map
        end

        def antinodes
          found_nodes = Hash.new { Set.new }

          map.elements.each do |element, position|
            next unless element.in?(PYLONS)

            found_nodes[element] = found_nodes[element] << position
          end

          # Now for each pair of similar nodes, calculate the resonance,
          # and filter out any points that aren't inside the map.
          found_nodes.values.
            map { |nodes| NodeGroup.new(nodes).resonance_points }.
            reduce(:+).
            filter { |x, y| map.contains?(x, y) }.
            to_set
        end
      end

      class NodeGroup
        attr_reader :nodes

        def initialize(nodes)
          @nodes = nodes
        end

        # My matrix algebra is a bit rusty so this is how this works.
        #
        # Let's take an example matrix:
        #
        #   N * * *
        #   * P * *
        #   * * P *
        #   * * * N
        #
        # This is a compact example where each node is offset by one diagonal
        # position from the pylon. The pylons are at [1, 1] and [2, 2]. The nodes
        # are at [0, 0] and [3, 3].
        #
        # Let's assume we get the pylons in an arbitrary order:
        #
        #   node_1 = [1, 1] and node_2 = [2, 2]
        #
        # The offset between them is then:
        #
        #   node_1 - node_2 = [-1, -1]
        #   n1 = node_1 + offset and n2 = node_2 - offset
        #
        # Does this rule always work?
        #
        #   node_1 = [2, 2] and node_2 = [1, 1]
        #   node_1 - node_2 = [1, 1]
        #   n1 = node_1 + offset and n2 = node_2 - offset
        #
        # Success!
        def resonance_points
          node_pairs.map do |node_1, node_2|
            offset = node_1.zip(node_2).map { |p| p.reduce(:-) }

            [
              node_1.zip(offset).map(&:sum),
              node_2.zip(offset).map { |p| p.reduce(:-) },
            ]
          end.reduce(:+)
        end

        def node_pairs
          @node_pairs ||= nodes.to_a.combination(2)
        end
      end

      class StringMatrix
        OutOfBoundsError = Class.new(IndexError)

        attr_reader :rows, :x_max, :y_max

        def initialize(rows)
          @rows = rows
          @x_max = rows.first.size - 1
          @y_max = rows.size - 1
        end

        def element(x, y)
          raise IndexError if x.negative? || y.negative?

          rows.fetch(y).fetch(x)
        rescue IndexError
          raise OutOfBoundsError
        end

        # Iterates across each row, left-to-right, top-to-bottom.
        # It returns the element and the co-ordinate.
        def elements
          Enumerator.new do |yielder|
            (0..y_max).each do |y|
              (0..x_max).each do |x|
                yielder.yield element(x, y), [x, y]
              end
            end
          end
        end

        def contains?(x, y)
          element(x, y).present?
        rescue OutOfBoundsError
          false
        end
      end

      class Map < StringMatrix
        def self.from_raw(raw_map)
          new(
            raw_map.
              split("\n").
              map(&:chars),
          )
        end
      end

      def initialize(problem)
        @raw_problem = problem
      end

      def solution_part1
        AntinodeFinder.new(map).antinodes.count
      end

      def map
        @map ||= Map.from_raw(raw_problem)
      end

      private

      attr_reader :raw_problem
    end
  end
end

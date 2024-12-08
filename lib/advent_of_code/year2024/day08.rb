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

        def antinodes(limit: true)
          found_nodes = Hash.new { Set.new }

          map.elements.each do |element, coord|
            next unless element.in?(PYLONS)

            found_nodes[element] = found_nodes[element] << coord
          end

          coords = if limit
                     # Now for each pair of similar nodes, calculate the resonance,
                     # and filter out any points that aren't inside the map.
                     found_nodes.values.map do |coords|
                       CoordGroup.new(coords).resonance_points
                     end.reduce(:+)
                   else
                     found_nodes.values.map do |coords|
                       CoordGroup.new(coords).all_resonance_points_within(map.x_max, map.y_max)
                     end.reduce(:+)
                   end

          coords.filter { |coord| map.contains?(coord) }.to_set
        end
      end

      class CoordGroup
        attr_reader :coords

        def initialize(coords)
          @coords = coords
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
            [resonance_point_for(node_1, node_2), resonance_point_for(node_2, node_1)]
          end.reduce(:+)
        end

        def all_resonance_points_within(x_max, y_max)
          node_pairs.map do |node_1, node_2|
            all_resonance_points_for(node_1, node_2, x_max, y_max) +
              all_resonance_points_for(node_2, node_1, x_max, y_max) +
              [node_1, node_2] # The antennas are also antinodes.
          end.reduce(:+)
        end

        def all_resonance_points_for(node_1, node_2, x_max, y_max)
          point = node_1 + (node_1 - node_2)

          return [] if point.negative? || point.x > x_max || point.y > y_max

          [point] + all_resonance_points_for(point, node_1, x_max, y_max)
        end

        def resonance_point_for(node_1, node_2)
          node_1 + (node_1 - node_2)
        end

        def node_pairs
          @node_pairs ||= coords.to_a.combination(2)
        end
      end

      class Coord
        attr_reader :x, :y

        def initialize(x, y)
          @x = x
          @y = y
        end

        def +(other)
          self.class.new(x + other.x, y + other.y)
        end

        def -(other)
          self.class.new(x - other.x, y - other.y)
        end

        def negative?
          x.negative? || y.negative?
        end

        def to_a
          [x, y]
        end

        def ==(other)
          to_a == other.to_a
        end

        alias_method :inspect, :to_a
        alias_method :eql?, :==

        delegate :hash, to: :to_a
      end

      class StringMatrix
        OutOfBoundsError = Class.new(IndexError)

        attr_reader :rows, :x_max, :y_max

        def initialize(rows)
          @rows = rows
          @x_max = rows.first.size - 1
          @y_max = rows.size - 1
        end

        def element(coord)
          raise IndexError if coord.negative?

          rows.fetch(coord.y).fetch(coord.x)
        rescue IndexError
          raise OutOfBoundsError
        end

        # Iterates across each row, left-to-right, top-to-bottom.
        # It returns the element and the co-ordinate.
        def elements
          Enumerator.new do |yielder|
            (0..y_max).each do |y|
              (0..x_max).each do |x|
                Coord.new(x, y).then do |coord|
                  yielder.yield element(coord), coord
                end
              end
            end
          end
        end

        def contains?(coord)
          element(coord).present?
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

      def solution_part2
        AntinodeFinder.new(map).antinodes(limit: false).count
      end

      def map
        @map ||= Map.from_raw(raw_problem)
      end

      private

      attr_reader :raw_problem
    end
  end
end

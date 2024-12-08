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

          resonance_points = found_nodes.values.map do |coords|
            if limit
              CoordGroup.new(coords).resonance_points
            else
              CoordGroup.new(coords).all_resonance_points_within(map.limit)
            end
          end

          resonance_points.
            reduce(:+).
            filter { |coord| map.contains?(coord) }.to_set
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

        def all_resonance_points_within(limit)
          node_pairs.map do |node_1, node_2|
            all_resonance_points_for(node_1, node_2, limit) +
              all_resonance_points_for(node_2, node_1, limit) +
              [node_1, node_2] # The antennas are also antinodes.
          end.reduce(:+)
        end

        private

        def all_resonance_points_for(node_1, node_2, limit)
          point = resonance_point_for(node_1, node_2)

          return [] if point.negative? || point > limit

          [point] + all_resonance_points_for(point, node_1, limit)
        end

        def resonance_point_for(node_1, node_2)
          node_1 + (node_1 - node_2)
        end

        def node_pairs
          @node_pairs ||= coords.to_a.combination(2)
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

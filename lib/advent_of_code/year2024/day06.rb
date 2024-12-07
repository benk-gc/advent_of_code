# frozen_string_literal: true

module AdventOfCode
  module Year2024
    class Day06
      class Scenario
        UnknownTileError = Class.new(ArgumentError)

        attr_reader :map, :guard

        def initialize(raw_map)
          @map = Map.from_raw(raw_map)
          @guard = Guard.from_raw(raw_map)
        end

        # On each tick we either move or turn depending on if we hit an obstacle.
        # We return the position of the guard after the action.
        # Once we try to move outside of the bounds of the map we raise an exception.
        # If we find an unexpected type of tile we also raise an exception.
        def tick!
          case next_tile
          when Map::OBSTACLE then guard.turn!
          when Map::FREE then guard.move!
          else
            raise UnknownTileError, "What the heck is #{next_tile}!"
          end

          guard.current_position
        end

        def next_tile
          map.element(*guard.next_position)
        end
      end

      class StringMatrix
        OutOfBoundsError = Class.new(IndexError)

        attr_reader :rows

        def initialize(rows)
          @rows = rows
        end

        def element(x, y)
          raise IndexError if x.negative? || y.negative?

          rows.fetch(y).fetch(x)
        rescue IndexError
          raise OutOfBoundsError
        end
      end

      class Map < StringMatrix
        FREE = "."
        OBSTACLE = "#"

        def self.from_raw(raw_map)
          new(
            raw_map.
              gsub(/[^#{FREE}#{OBSTACLE}\s]/o, ".").
              split("\n").
              map(&:chars),
          )
        end
      end

      class Guard
        DIRECTIONS = [:up, :right, :down, :left].freeze
        CHARACTERS = ["^", ">", "v", "<"].freeze

        def self.from_raw(raw_map)
          raw_map.split("\n").map(&:chars).each_with_index do |row, y|
            guard = row.find { |elem| elem.in?(CHARACTERS) }

            return new(guard, row.index(guard), y) if guard
          end

          raise ArgumentError, "There's no guard on this map!"
        end

        attr_reader :current_position, :current_direction

        def initialize(char, x, y)
          @current_position = [x, y]
          @current_direction = DIRECTIONS.fetch(CHARACTERS.index(char))
        end

        def turn!
          @current_direction = DIRECTIONS.fetch(
            (DIRECTIONS.index(current_direction) + 1) % 4,
          )
        end

        def move!
          @current_position = next_position
        end

        def next_position
          current_position.zip(movement).map(&:sum)
        end

        private

        def movement
          case current_direction
          when :up then [0, -1]
          when :right then [1, 0]
          when :down then [0, 1]
          when :left then [-1, 0]
          else
            raise "#{current_direction} isn't a valid direction"
          end
        end
      end

      def initialize(raw_problem = PROBLEM)
        @raw_problem = raw_problem
      end

      def solution_part1
        visited_tiles = Set.new

        loop do
          visited_tiles.add(scenario.guard.current_position)
          scenario.tick!
        rescue StringMatrix::OutOfBoundsError
          break
        end

        visited_tiles.count
      end

      def scenario
        @scenario ||= Scenario.new(raw_problem)
      end

      private

      attr_reader :raw_problem
    end
  end
end

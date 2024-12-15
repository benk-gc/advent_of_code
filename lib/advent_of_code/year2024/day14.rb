# frozen_string_literal: true

module AdventOfCode
  module Year2024
    class Day14
      class Scenario
        attr_reader :map, :actors

        def initialize(map, actors)
          @map = map
          @actors = actors
        end

        def solve(ticks)
          x_mid, y_mid = map.limit.to_a.map { |c| c.fdiv(2).ceil }

          # Move the actors the required number of times.
          # We could optimise this to a single operation per actor.
          actors.each do |actor|
            ticks.times { actor.move_with_wraparound!(map) }
          end

          actors.
            # Filter out actors in the middle.
            reject { |a| a.x == x_mid || a.y == y_mid }.
            # Split into halves.
            partition { |a| a.y < y_mid }.
            # Split into quarters.
            map { |half| half.partition { |a| a.x < x_mid } }.
            # Make a single-dimensional array.
            reduce(:+).
            # Calculate the safety factor.
            map(&:count).reduce(:*)
        end
      end

      class ActorParser
        def self.from_raw(string)
          string.split("\n").map(&:split).map do |pos, vec|
            Actor.new(
              class_eval(pos.sub("p=", "s2c ")),
              class_eval(vec.sub("v=", "s2c ")),
            )
          end
        end

        def self.s2c(x, y)
          Coord.new(x, y)
        end
      end

      def initialize(problem)
        @raw_problem = problem
      end

      def solution_part1
        Scenario.new(generate_map, parse_actors).solve(100)
      end

      def solution_part2
        map = generate_map
        actors = parse_actors
        actor_count = actors.count
        actor_char = "x"

        (0..20_000).each do |tick|
          tick_map = generate_map

          actors.each { |a| tick_map.write(actor_char, a.current_position) }

          return tick if tick_map.vertical_symmetry(actor_count, actor_char) > 0.5

          actors.each { |a| a.move_with_wraparound!(map) }
        end

        "no answer found"
      end

      private

      def generate_map
        row = Array.new(101, ".")
        Map.new(Array.new(103) { row.dup })
      end

      def parse_actors
        ActorParser.from_raw(raw_problem)
      end

      attr_reader :raw_problem
    end
  end
end

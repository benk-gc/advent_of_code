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
        map = Map.new(Array.new(103, Array.new(101, ".")))
        actors = ActorParser.from_raw(raw_problem)
        Scenario.new(map, actors).solve(100)
      end

      def solution_part2(tstart = 1, interval = 20_000, threshold = 0.5)
        tend = tstart + interval
        map = Map.new(Array.new(103, Array.new(101, ".")))
        actors = ActorParser.from_raw(raw_problem)
        actor_count = actors.count
        actor_char = "x"

        (tstart..tend).each do |tick|
          row = Array.new(101, ".")
          tick_map = Map.new(Array.new(103) { row.dup })

          actors.each { |a| tick_map.write(actor_char, a.current_position) }

          symmetry = tick_map.vertical_order(actor_count, actor_char)

          if symmetry > threshold
            # debug helper
            # puts "Tick: #{tick}\nSymmetry: #{symmetry}\n\n" + tick_map.draw + "\n---\n"

            # Technically the number of seconds is 1 behind the tick.
            return tick - 1
          end

          actors.each { |a| a.move_with_wraparound!(map) }
        end

        "no answer found"
      end

      private

      attr_reader :raw_problem
    end
  end
end

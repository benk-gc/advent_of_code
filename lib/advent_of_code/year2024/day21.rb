# frozen_string_literal: true

module AdventOfCode
  module Year2024
    class Day21
      class Solver
        MOVEMENTS = {
          Coord.new(0, -1) => "^",
          Coord.new(1, 0) => ">",
          Coord.new(0, 1) => "v",
          Coord.new(-1, 0) => "<",
        }.freeze

        attr_reader :keypad

        def initialize(keypad)
          @keypad = keypad
          @solution_cache = {}
        end

        def activation_sequence(buttons)
          # The robot always start at A.
          buttons = ["A"] + buttons

          puts "#{buttons.count} buttons" if ENV["AOC_DEBUG"]

          movements = []

          buttons.each_cons(2).each do |from, to|
            cache_key = [from, to]
            cached_solution = @solution_cache[cache_key]

            if cached_solution
              movements.push(*cached_solution)
              next
            else
              solution = translate_movements(
                keypad.navigate(
                  from_coord: keypad.position(from),
                  to_coord: keypad.position(to),
                ),
              ) + ["A"]

              @solution_cache[cache_key] = solution

              movements.push(*solution)
            end
          end

          movements
        end

        # Translate the movements into directional instructions.
        def translate_movements(movements)
          movements.map { |vec| MOVEMENTS.fetch(vec) }
        end
      end

      def initialize(problem)
        @raw_problem = problem
      end

      def solve(buttons, robots: 2)
        puts "#{Time.now} solving" if ENV["AOC_DEBUG"]

        numeric_solver = Solver.new(numeric_keypad)
        directional_solver = Solver.new(directional_keypad)

        results = [
          buttons.join,
          # First robot 1 types the code on the numeric keypad.
          numeric_solver.activation_sequence(buttons),
        ]

        robots.times.each do |i|
          puts "#{Time.now} robot #{i}" if ENV["AOC_DEBUG"]
          results << directional_solver.activation_sequence(results.last)
        end

        if ENV["AOC_DEBUG"]
          puts results.reverse
          puts "#{results.last.length} * #{buttons[0..3].join.to_i}"
          puts results.last.length * buttons[0..3].join.to_i

          puts "---"
        end

        results.last.length * buttons[0..3].join.to_i
      end

      def solution_part1
        button_sequences.
          map { |buttons| solve(buttons, robots: 2) }.
          sum
      end

      def solution_part2
        button_sequences.
          map { |buttons| solve(buttons, robots: 25) }.
          sum
      end

      def button_sequences
        @button_sequences ||= raw_problem.split("\n").map(&:chars)
      end

      def numeric_keypad
        @numeric_keypad ||= Keypad.from_raw(
          <<~TXT.chomp,
            789
            456
            123
            .0A
          TXT
        )
      end

      def directional_keypad
        @directional_keypad ||= Keypad.from_raw(
          <<~TXT.chomp,
            .^A
            <v>
          TXT
        )
      end

      private

      attr_reader :raw_problem
    end
  end
end

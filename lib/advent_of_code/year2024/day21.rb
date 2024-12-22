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
        end

        def activation_sequence(buttons)
          # The robot always start at A.
          buttons = ["A"] + buttons

          movements = buttons.each_cons(2).map do |from, to|
            translate_movements(
              keypad.navigate(
                from_coord: keypad.position(from),
                to_coord: keypad.position(to),
              ),
            )
          end

          # Join the movements and activations, remembering to activate
          # the last button as well.
          movements.map(&:join).join("A") + "A"
        end

        # Translate the movements into directional instructions.
        def translate_movements(movements)
          movements.map { |vec| MOVEMENTS.fetch(vec) }
        end
      end

      def initialize(problem)
        @raw_problem = problem
      end

      def solve(buttons)
        numeric_solver = Solver.new(numeric_keypad)
        directional_solver = Solver.new(directional_keypad)

        # First robot 1 types the code on the numeric keypad.
        solution_1 = numeric_solver.activation_sequence(buttons)

        # Then robot 2 types these buttons on the directional keypad.
        solution_2 = directional_solver.activation_sequence(solution_1.chars)

        # Then the second robot types these buttons on the directional keypad.
        solution_3 = directional_solver.activation_sequence(solution_2.chars)

        # Then finally you type these on your directional pad.
        results = [
          solution_3,
          solution_2,
          solution_1,
          buttons.join,
        ]

        if ENV["AOC_DEBUG"]
          puts results
          puts "#{solution_3.length} * #{buttons[0..3].join.to_i}"
          puts solution_3.length * buttons[0..3].join.to_i

          puts "---"
        end

        solution_3.length * buttons[0..3].join.to_i
      end

      def solution_part1
        button_sequences.
          map { |buttons| solve(buttons) }.
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

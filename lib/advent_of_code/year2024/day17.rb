# frozen_string_literal: true

# Solving this problem involved the novel optimisation of updating Ruby
# to 3.4.0-rc1 to include this fix for calculating large exponents:
# https://bugs.ruby-lang.org/issues/20811.
module AdventOfCode
  module Year2024
    class Day17
      class OpTuple
        INSTRUCTIONS = {
          0 => :adv,
          1 => :bxl,
          2 => :bst,
          3 => :jnz,
          4 => :bxc,
          5 => :out,
          6 => :bdv,
          7 => :cdv,
        }.freeze

        attr_reader :instruction, :operand

        def initialize(instruction, operand)
          @instruction = INSTRUCTIONS.fetch(instruction)
          @operand = operand
        end
      end

      class Parser
        def self.parse_problem(raw_input)
          registers, raw_program = raw_input.split("\n\n")

          register_a, register_b, register_c = registers.
            split("\n").map { |l| l.split.last.to_i }

          program = Parser.parse_program(raw_program)

          [register_a, register_b, register_c, program]
        end

        def self.parse_program(raw_program)
          raw_program.split.last.split(",").map(&:to_i)
        end
      end

      class Computer
        Jump = Class.new(StandardError)
        Halt = Class.new(StandardError)

        def self.run(raw_input)
          register_a, register_b, register_c, program = Parser.parse_problem(raw_input)

          new(register_a, register_b, register_c).run(program)
        end

        attr_reader :register_a, :register_b, :register_c,
                    :instruction_pointer, :output

        def initialize(register_a = 0, register_b = 0, register_c = 0)
          @register_a = register_a
          @register_b = register_b
          @register_c = register_c

          @instruction_pointer = 0
          @output = []
        end

        def run(program)
          loop do
            raise "Invalid instruction pointer" if instruction_pointer.odd?

            instruction = program.fetch(instruction_pointer) { raise Halt }
            operand = program.fetch(instruction_pointer + 1) { raise Halt }
            op_tuple = OpTuple.new(instruction, operand)

            if ENV["AOC_DEBUG"]
              puts "DEBUG: pointer #{instruction_pointer}"
              puts "DEBUG: #{register_a}, #{register_b}, #{register_c}"
              puts "DEBUG: #{op_tuple.instruction}, #{op_tuple.operand}"
            end

            send(op_tuple.instruction, op_tuple.operand)

            @instruction_pointer += 2
          rescue Jump
            # Don't increment the instruction pointer on a jump.
          rescue Halt
            # Halt the program execution.
            break
          end

          output.join(",")
        end

        def adv(combo_operand)
          @register_a = dv(combo_operand)
        end

        def bxl(literal_operand)
          @register_b = register_b ^ literal_operand
        end

        def bst(combo_operand)
          @register_b = combo(combo_operand) % 8
        end

        def jnz(literal_operand)
          return if register_a.zero?

          @instruction_pointer = literal_operand

          raise Jump
        end

        def bxc(_ignored_operand)
          @register_b = register_b ^ register_c
        end

        def out(combo_operand)
          @output << (combo(combo_operand) % 8)
        end

        def bdv(combo_operand)
          @register_b = dv(combo_operand)
        end

        def cdv(combo_operand)
          @register_c = dv(combo_operand)
        end

        def combo(operand)
          case operand
          when 0, 1, 2, 3 then operand
          when 4 then register_a
          when 5 then register_b
          when 6 then register_c
          when 7 then raise "Used illegal operand 7"
          else
            raise "Unrecognised combo operand #{operand}"
          end
        end

        private

        def dv(combo_operand)
          register_a.fdiv(2**combo(combo_operand)).floor
        end
      end

      def initialize(problem)
        @raw_problem = problem
      end

      def solution_part1
        Computer.run(raw_problem)
      end

      def solution_part2
        _, register_b, register_c, program = Parser.parse_problem(raw_problem)
        expected_output = program.join(",")

        (0..1_000_000_000).each do |register_a|
          output = Computer.new(register_a, register_b, register_c).run(program)

          return i if output == expected_output
        end

        "no solution found"
      end

      private

      attr_reader :raw_problem
    end
  end
end

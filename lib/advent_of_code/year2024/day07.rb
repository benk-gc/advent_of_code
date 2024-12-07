# frozen_string_literal: true

class Integer
  def join(other)
    (to_s + other.to_s).to_i
  end
end

module AdventOfCode
  module Year2024
    class Day07
      class Permuter
        EarlyFailureError = Class.new(StandardError)

        attr_reader :equation, :operators

        def initialize(equation, joins: false)
          @equation = equation
          @operators = joins ? [:+, :*, :join] : [:+, :*]
        end

        def plausible?
          results = values.reduce([]) do |memo, next_value|
            next [next_value] if memo.empty?

            memo.map do |memo_value|
              operators.filter_map do |op|
                memo_value.send(op, next_value).then do |result|
                  result > solution ? nil : result # Abort failed branches early.
                end
              end
            end.flatten
          end

          results.any?(solution)
        end

        delegate :values, :solution, to: :equation
      end

      class Equation
        DELIMITER = ": "

        attr_reader :solution, :values

        def self.from_string(string)
          parts = string.split(DELIMITER)

          new(parts.first.to_i, parts.second.split.map(&:to_i))
        end

        def initialize(solution, values)
          @solution = solution
          @values = values
        end
      end

      def initialize(problem)
        @raw_problem = problem
      end

      def solution_part1
        equations.filter { |eq| Permuter.new(eq).plausible? }.sum(&:solution)
      end

      def solution_part2
        part1_pass, part1_fail = equations.partition { |eq| Permuter.new(eq).plausible? }
        part2_pass = part1_fail.filter { |eq| Permuter.new(eq, joins: true).plausible? }

        (part1_pass + part2_pass).sum(&:solution)
      end

      def equations
        @equations ||= raw_problem.split("\n").map { |line| Equation.from_string(line) }
      end

      private

      attr_reader :raw_problem
    end
  end
end

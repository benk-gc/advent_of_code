# frozen_string_literal: true

module AdventOfCode
  module Year2024
    class Day07
      class Permuter
        EarlyFailureError = Class.new(StandardError)

        OPERATORS = [:+, :*].freeze

        attr_reader :equation

        def initialize(equation)
          @equation = equation
        end

        def plausible?
          each_operator_combination.any? do |ops|
            result = equation.values.reduce do |memo, value|
              raise EarlyFailureError if memo > solution

              memo.send(ops.shift, value)
            end

            result == solution
          rescue EarlyFailureError
            false
          end
        end

        def each_operator_combination(&block)
          cons = values.count - 1

          (OPERATORS * cons).combination(cons).lazy(&block)
        end

        def interleave(arr1, arr2)
          arr1.zip(arr2).flatten.compact
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

      def solution
        raw_problem.
          split("\n").
          map { |line| Equation.from_string(line) }.
          map { |eq| Permuter.new(eq) }.
          filter(&:plausible?).
          sum(&:solution)
      end

      private

      attr_reader :raw_problem
    end
  end
end

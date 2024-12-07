# frozen_string_literal: true

module AdventOfCode
  module Year2024
    class Day05
      PROBLEM = <<~TXT.chomp
        47|53
        97|13
        97|61
        97|47
        75|29
        61|13
        75|53
        29|13
        97|29
        53|29
        61|53
        97|53
        61|29
        47|13
        75|47
        97|75
        47|61
        75|61
        47|29
        75|13
        53|13

        75,47,61,53,29
        97,61,53,29,13
        75,29,13
        75,97,47,61,53
        61,13,29
        97,13,75,29,47
      TXT

      Problem = Struct.new(:constraints, :lines, keyword_init: true) do
        def self.parse(problem)
          problem.split("\n\n").then do |constraints, lines|
            new(
              constraints: parse_text(constraints, separator: "|"),
              lines: parse_text(lines, separator: ","),
            )
          end
        end

        def self.parse_text(text, separator:)
          text.split("\n").map do |line|
            line.split(separator).map(&:to_i)
          end
        end
      end

      Constraints = Struct.new(:befores, :afters, keyword_init: true) do
        def self.build(constraints)
          new(befores: Hash.new { Set[] }, afters: Hash.new { Set[] }).tap do |c|
            constraints.each do |first_page, second_page|
              c.befores[second_page] = c.befores[second_page].add(first_page)
              c.afters[first_page] = c.afters[first_page].add(second_page)
            end
          end
        end
      end

      class Lines < Array
        def self.build(lines)
          new(lines.map { |line| Line[*line] })
        end

        def filter_valid(constraints)
          filter { |line| line.valid?(constraints) }
        end
      end

      class Line < Array
        def valid?(constraints)
          each_with_before_after.all? do |element, befores, afters|
            constraints.befores[element].intersection(afters).empty? &&
              constraints.afters[element].intersection(befores).empty?
          end
        end

        def each_with_before_after
          Enumerator.new do |yielder|
            each_with_index do |element, index|
              yielder.yield element, befores(index), afters(index)
            end
          end
        end

        def middle
          raise "This line doesn't have a middle" if size.even?

          fetch(size / 2)
        end

        private

        def befores(index)
          slice(...index).to_set
        end

        def afters(index)
          slice((index + 1)...).to_set
        end
      end

      def initialize(raw_problem = PROBLEM)
        @raw_problem = raw_problem
      end

      def solution_part1
        lines.filter_valid(constraints).sum(&:middle)
      end

      def problem
        @problem ||= Problem.parse(raw_problem)
      end

      def constraints
        @constraints ||= Constraints.build(problem.constraints)
      end

      def lines
        @lines ||= Lines.build(problem.lines)
      end

      private

      attr_reader :raw_problem
    end
  end
end

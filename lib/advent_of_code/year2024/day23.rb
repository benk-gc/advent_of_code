# frozen_string_literal: true

module AdventOfCode
  module Year2024
    class Day23
      class Node
        attr_accessor :connections

        def initialize
          @connections = []
        end
      end

      class Graph
        attr_reader :nodes

        def initialize
          @nodes = {}
        end
      end

      class Solver
        attr_reader :graph

        def initialize(graph)
          @graph = graph
        end

        def solve(group_size:)
          combinations = graph.nodes.flat_map do |parent, node|
            node.connections.
              combination(group_size - 1).
              map { |com| com << parent }.
              map(&:to_set)
          end

          combinations.tally.filter { |_k, v| v == group_size }.keys
        end
      end

      def initialize(problem)
        @raw_problem = problem
      end

      def solution_part1
        Solver.new(graph).
          solve(group_size: 3).
          count { |group| group.any? { |v| v.start_with?("t") } }
      end

      def solution_part2
        num_computers = graph.nodes.count
        solver = Solver.new(graph)

        (1..num_computers).to_a.reverse_each do |group_size|
          solutions = solver.solve(group_size: group_size)

          next unless solutions.any?

          raise "More than one solution found for #{group_size}" if solutions.count > 1

          return solutions.first.sort.join(",")
        end

        raise "no solution found"
      end

      def graph
        @graph ||= Graph.new.tap do |graph|
          pairs = raw_problem.
            split("\n").
            map { |line| line.split("-") }

          pairs.flatten.uniq.each { |n| graph.nodes[n] = Node.new }

          pairs.each do |a, b|
            graph.nodes[a].connections << b
            graph.nodes[b].connections << a
          end
        end
      end

      private

      attr_reader :raw_problem
    end
  end
end

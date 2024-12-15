# frozen_string_literal: true

module AdventOfCode
  module Year2024
    class Day15
      class Scenario
        ROBOT = "@"
        BOX = "O"
        WALL = "#"
        SPACE = "."

        MOVEMENTS = { "^" => :up, ">" => :right, "v" => :down, "<" => :left }.freeze

        def self.from_raw(raw_problem)
          raw_map, raw_movements = raw_problem.split("\n\n")
          map = Map.from_raw(raw_map)
          movements = raw_movements.delete("\n").chars.map { |c| MOVEMENTS.fetch(c) }

          # Find the robot.
          robot_coord = map.elements.find { |char, _coord| char == ROBOT }.pop
          map.write(SPACE, robot_coord)
          robot = Robot.new(robot_coord)

          new(map, robot, movements)
        end

        attr_reader :map, :robot, :movements

        def initialize(map, robot, movements)
          @map = map
          @robot = robot
          @movements = movements
        end

        def solve!
          simulate!

          map.elements.sum do |char, coord|
            char == BOX ? (100 * coord.y) + coord.x : 0
          end
        end

        def simulate!
          movements.each do |direction|
            next_position = robot.next_position(direction)
            next_tile = map.element(next_position)

            case next_tile
            when SPACE
              robot.move!(direction)
            when BOX
              next_space = map.look_for(
                SPACE,
                from: robot.current_position,
                direction: direction,
                blockers: [WALL],
              )

              if next_space
                map.transpose(next_position, next_space)
                robot.move!(direction)
              end
            when WALL
              # Robot stays where it is.
            else
              raise "Unknown type of tile: '#{next_tile}'"
            end
          end
        end
      end

      def initialize(problem)
        @raw_problem = problem
      end

      def solution_part1
        Scenario.from_raw(raw_problem).solve!
      end

      private

      attr_reader :raw_problem
    end
  end
end

# frozen_string_literal: true

class Keypad < Map
  InvalidSolution = Class.new(StandardError)

  EMPTY = "."

  attr_reader :buttons, :home_key

  def initialize(rows)
    super
    @buttons = elements.to_h

    if buttons.count != elements.count
      raise "This keypad doesn't have unique buttons"
    end

    @home_key = position("A")
    @solution_cache = {}
  end

  def position(button_char)
    buttons.fetch(button_char)
  end

  # Not particularly optimal - it just tries all possible solutions until
  # one of them works. If the problem is very big this will be slow.
  def navigate(from_coord:, to_coord:)
    decompose(to_coord - from_coord).each do |solution|
      solution.inject([from_coord]) do |moves, move|
        next_tile = moves.last + move

        raise InvalidSolution if element(next_tile) == EMPTY

        moves << next_tile
      end

      return solution
    rescue InvalidSolution
      next
    end

    raise "No solution was found"
  end

  UP_RIGHT = [
    Coord.new(0, -1),
    Coord.new(1, 0),
  ].freeze

  def decompose(movement)
    return [[]] if movement == Coord.new(0, 0)

    horizontal_vector = movement.x.zero? ? nil : horizontal_vector(movement.x)
    vertical_vector = movement.y.zero? ? nil : vertical_vector(movement.y)

    possible_moves = Array.new(movement.x.abs) { horizontal_vector.clone } +
      Array.new(movement.y.abs) { vertical_vector.clone }

    # Make each movement as efficient as possible. @todo delegate this to a dependency
    # Firstly we want to prioritise those that do the fewest moves between keys.
    # Then we also want to optimise for move order. The least efficient
    possible_moves.permutation(possible_moves.count).sort_by do |permutation|
      weight = permutation.each_cons(2).inject(0) do |sum, mvs|
        sum + weighting_function(mvs.first, mvs.second)
      end

      # Considering how we'd navigate to these positions on a numeric keypad, also get the
      # final position and check it against the position of A. We need to do the button
      # mapping as if the final move was a key. Up and Right have a weight of 1, left and down
      # a weighting of 2
      weight + (permutation.last.in?(UP_RIGHT) ? 1 : 2)
    end
  end

  # Weighting is the distance between the two points.
  def weighting_function(to, from)
    (from - to).to_a.map(&:abs).sum
  end

  def horizontal_vector(x)
    Coord.new(x / x.abs, 0)
  end

  def vertical_vector(y)
    Coord.new(0, y / y.abs)
  end
end

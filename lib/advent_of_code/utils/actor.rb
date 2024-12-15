# frozen_string_literal: true

class Actor
  attr_reader :current_position, :movement_vector

  def initialize(current_position, movement_vector)
    @current_position = current_position
    @movement_vector = movement_vector
  end

  def move!
    @current_position = next_position
  end

  def move_with_wraparound!(map)
    @current_position = next_position_wraparound(map)
  end

  def next_position
    current_position + movement_vector
  end

  def next_position_wraparound(map)
    new_position = current_position + movement_vector

    Coord.new(
      new_position.x % (map.limit.x + 1),
      new_position.y % (map.limit.y + 1),
    )
  end

  delegate :x, to: :current_position
  delegate :y, to: :current_position
end

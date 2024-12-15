# frozen_string_literal: true

require_relative "movement"

class Map < StringMatrix
  include Movement

  def self.from_raw(raw_map)
    new(
      raw_map.
        split("\n").
        map(&:chars),
    )
  end

  def look_for(char, from:, direction:, blockers:)
    current_position = from.clone
    movement_vector = dir2vec(direction)

    1000.times do
      current_position += movement_vector
      current_char = element(current_position)

      return nil if current_char.in?(blockers)
      return current_position if current_char == char
    end

    raise "This map appears to be boundless"
  rescue OutOfBoundsError
    nil
  end
end

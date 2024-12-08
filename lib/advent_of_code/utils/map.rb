# frozen_string_literal: true

class Map < StringMatrix
  def self.from_raw(raw_map)
    new(
      raw_map.
        split("\n").
        map(&:chars),
    )
  end
end

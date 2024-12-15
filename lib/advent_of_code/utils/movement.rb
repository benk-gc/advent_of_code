# frozen_string_literal: true

module Movement
  def dir2vec(direction)
    case direction
    when :up then Coord.new(0, -1)
    when :right then Coord.new(1, 0)
    when :down then Coord.new(0, 1)
    when :left then Coord.new(-1, 0)
    else
      raise ArgumentError, "#{direction} isn't a valid direction"
    end
  end
end

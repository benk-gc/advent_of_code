# frozen_string_literal: true

class StringMatrix
  OutOfBoundsError = Class.new(IndexError)

  attr_reader :rows, :limit

  def initialize(rows)
    @rows = rows
    @limit = Coord.new(rows.first.size - 1, rows.size - 1)
  end

  def element(coord)
    raise IndexError if coord.negative?

    rows.fetch(coord.y).fetch(coord.x)
  rescue IndexError
    raise OutOfBoundsError
  end

  # Iterates across each row, left-to-right, top-to-bottom.
  # It returns the element and the co-ordinate.
  def elements
    Enumerator.new do |yielder|
      (0..limit.y).each do |y|
        (0..limit.x).each do |x|
          Coord.new(x, y).then do |coord|
            yielder.yield element(coord), coord
          end
        end
      end
    end
  end

  def write(char, coord)
    raise OutOfBoundsError unless contains?(coord)

    @rows[coord.y][coord.x] = char
  end

  def draw
    rows.map(&:join).join("\n")
  end

  def contains?(coord)
    element(coord).present?
  rescue OutOfBoundsError
    false
  end

  def vertical_order(element_total, match_char)
    x_mid = limit.x.fdiv(2).ceil

    # We can do this in a single pass over a half, by iterating and finding all
    # elements, the checking if they correspond to an element on the other side.
    match_count = (0..limit.y).sum do |y|
      (0..x_mid).sum do |x|
        left_char = element(Coord.new(x, y))

        # We don't want to count background chars.
        next 0 unless left_char == match_char

        # If we're on the midline, the character is always a match.
        next 1 if x == x_mid

        right_char = element(Coord.new(limit.x - x, y))

        left_char == right_char ? 1 : 0
      end
    end

    # Technically this could be > 1 if we have lots on the midline.
    match_count.fdiv(element_total.fdiv(2))
  end
end

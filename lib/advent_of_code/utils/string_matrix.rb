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

  # Yes, we could do this in-place, but this is more readable.
  def transpose(a, b)
    char_a = element(a)
    char_b = element(b)
    write(char_b, a)
    write(char_a, b)
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

  # This isn't the most optimal way to do this - for a list of actors it's
  # faster to just partition the actions over the bounds of the matrix, but
  # this is a nice way to do this if we already have the characters in the
  # matrix. We could also trivially extend this for multiple characters.
  def vertical_symmetry(element_total, match_char)
    x_mid = limit.x.fdiv(2).ceil

    # We can do this in a single pass over a half, by iterating and finding all
    # elements, the checking if they correspond to an element on the other side.
    match_count = (0..limit.y).sum do |y|
      (0..x_mid).sum(0.0) do |x|
        left_char = element(Coord.new(x, y))

        # We don't want to count background chars.
        next 0.0 unless left_char == match_char

        # If we're on the midline in an odd matrix, the character is always a match.
        # Since this only eliminates a single character it counts as half a match.
        next 0.5 if x == x_mid && limit.x.even?

        left_char == element(Coord.new(limit.x - x, y)) ? 1.0 : 0.0
      end
    end

    match_count.fdiv(element_total.fdiv(2))
  end
end

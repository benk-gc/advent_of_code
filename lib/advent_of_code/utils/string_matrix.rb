# frozen_string_literal: true

class StringMatrix
  OutOfBoundsError = Class.new(IndexError)

  attr_reader :rows, :limit

  def initialize(rows)
    @rows = rows
    @limit ||= Coord.new(rows.first.size - 1, rows.size - 1)
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

  def contains?(coord)
    element(coord).present?
  rescue OutOfBoundsError
    false
  end
end

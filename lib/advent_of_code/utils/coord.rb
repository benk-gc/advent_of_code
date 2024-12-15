# frozen_string_literal: true

class Coord
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def +(other)
    self.class.new(x + other.x, y + other.y)
  end

  def -(other)
    self.class.new(x - other.x, y - other.y)
  end

  def *(other)
    self.class.new(x * other.x, y * other.x)
  end

  def >(other)
    x > other.x || y > other.y
  end

  def <(other)
    x < other.x || y < other.y
  end

  def negative?
    x.negative? || y.negative?
  end

  def to_a
    [x, y]
  end

  def ==(other)
    to_a == other.to_a
  end

  alias_method :inspect, :to_a
  alias_method :eql?, :==

  delegate :hash, to: :to_a
end

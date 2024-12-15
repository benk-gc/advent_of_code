# frozen_string_literal: true

require_relative "movement"

class Robot
  include Movement

  attr_reader :current_position

  def initialize(current_position)
    @current_position = current_position
  end

  def move!(direction)
    @current_position = next_position(direction)
  end

  def next_position(direction)
    current_position + dir2vec(direction)
  end

  delegate :x, to: :current_position
  delegate :y, to: :current_position
end

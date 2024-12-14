# frozen_string_literal: true

require "active_support/all"
require_relative "advent_of_code/utils"

Dir[File.join(__dir__, "advent_of_code", "year2024", "*.rb")].each do |f|
  require_relative f
end

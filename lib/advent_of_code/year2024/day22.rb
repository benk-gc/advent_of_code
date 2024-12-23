# frozen_string_literal: true

module AdventOfCode
  module Year2024
    class Day22
      class SecretNumberFinder
        attr_reader :start

        def initialize(start)
          @start = start
          @prices = nil
          @changes = nil
        end

        def find(iterations)
          iterations.times.inject(start) do |secret, _i|
            step3(step2(step1(secret)))
          end
        end

        def changes(prices)
          prices.map.with_index do |price, index|
            next price if index.zero?

            price - prices[index - 1]
          end
        end

        def prices(iterations)
          secret = start

          Array.new(iterations) do |_i|
            (secret % 10).tap do
              secret = step3(step2(step1(secret)))
            end
          end
        end

        def step1(secret)
          prune(mix(secret, secret * 64))
        end

        def step2(secret)
          prune(mix(secret, secret.fdiv(32).floor))
        end

        def step3(secret)
          prune(mix(secret, secret * 2048))
        end

        def mix(secret, value)
          secret ^ value
        end

        def prune(secret)
          secret % 16777216
        end
      end

      class ChangeSequence
        attr_reader :sequence, :price

        def initialize(sequence:, price:)
          @sequence = sequence
          @price = price
        end
      end

      class SequenceMixer
        attr_reader :changes, :prices

        def initialize(changes, prices)
          @changes = changes
          @prices = prices
        end

        def change_sequences
          changes.
            each_cons(4).
            with_index.
            map { |changes, index| ChangeSequence.new(sequence: changes, price: prices[index + 3]) }.
            # Ensure we only have the first occurring value for each
            # sequence, as this is where the price would stop.
            reverse.index_by(&:sequence).values
        end

        # Given a list of ChangeSequences, find the largest sum of prices for an
        # identical sequence.
        def self.mix(change_sequences)
          change_sequences.
            group_by(&:sequence).
            values.map { |v| v.sum(&:price) }.
            max
        end
      end

      def initialize(problem)
        @raw_problem = problem
      end

      def solution_part1
        secrets.sum do |num|
          SecretNumberFinder.new(num).find(2_000)
        end
      end

      def solution_part2
        change_sequences = secrets.flat_map do |secret|
          number_finder = SecretNumberFinder.new(secret)

          # Note we need 2_000 price changes, so 2_001 prices.
          prices = number_finder.prices(2_001)
          changes = number_finder.changes(prices)

          SequenceMixer.new(changes, prices).change_sequences
        end

        SequenceMixer.mix(change_sequences)
      end

      def secrets
        raw_problem.split("\n").map(&:to_i)
      end

      private

      attr_reader :raw_problem
    end
  end
end

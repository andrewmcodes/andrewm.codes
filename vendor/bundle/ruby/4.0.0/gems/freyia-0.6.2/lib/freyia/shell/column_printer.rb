# frozen_string_literal: true

require_relative "terminal"

module Freyia
  module Shell
    class ColumnPrinter
      attr_reader :stdout, :options

      def initialize(stdout, **options)
        @stdout = stdout
        @options = options
        @indent = options[:indent].to_i
      end

      def print(array) # rubocop:todo Metrics
        return if array.empty?

        colwidth = (array.map { |el| el.to_s.size }.max || 0) + 2
        array.each_with_index do |value, index|
          # Don't output trailing spaces when printing the last column
          if (((index + 1) % (Terminal.terminal_width / colwidth)).zero? && !index.zero?) ||
              index + 1 == array.length
            stdout.puts value
          else
            stdout.printf("%-#{colwidth}s", value)
          end
        end
      end
    end
  end
end

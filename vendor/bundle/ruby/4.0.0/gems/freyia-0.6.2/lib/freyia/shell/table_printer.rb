# frozen_string_literal: true

require_relative "column_printer"
require_relative "terminal"

module Freyia
  module Shell
    class TablePrinter
      BORDER_SEPARATOR = :separator

      # @return [IO]
      attr_reader :stdout

      # @return [Boolean]
      attr_reader :borders

      def initialize(stdout, indent: 0, colwidth: nil, truncate: false, borders: false) # rubocop:disable Metrics/ParameterLists
        @stdout = stdout
        @indent = indent.to_i
        @formats = []
        @maximas = []
        @colwidth = colwidth
        @truncate = truncate == true ? Terminal.terminal_width : truncate
        @borders = borders
        @padding = 1
      end

      def print(array) # rubocop:todo Metrics
        return if array.empty?

        prepare(array)

        print_border_separator if borders

        array.each do |row|
          if borders && row == BORDER_SEPARATOR
            print_border_separator
            next
          end

          sentence = +""

          row.each_with_index do |column, index|
            sentence << format_cell(column, row.size, index)
          end

          sentence = truncate(sentence)
          sentence << "|" if borders
          stdout.puts indentation + sentence
        end
        print_border_separator if borders
      end

      private

      def prepare(array) # rubocop:todo Metrics
        array = array.reject { |row| row == BORDER_SEPARATOR }

        @formats << "%-#{@colwidth + 2}s" if @colwidth
        start = @colwidth ? 1 : 0

        colcount = array.max_by(&:size).size

        start.upto(colcount - 1) do |index|
          maxima = array.map do |row|
            row[index] ? Shell::Color.strip_ansi(row[index].to_s).size : 0
          end.max

          @maximas << maxima
          @formats << if borders
                        "%-#{maxima}s"
                      elsif index == colcount - 1
                        # Don't output 2 trailing spaces when printing the last column
                        +"%-s"
                      else
                        "%-#{maxima + 2}s"
                      end
        end

        @formats << "%s"
      end

      def format_cell(column, row_size, index)
        maxima = @maximas[index]

        f = if column.is_a?(Numeric)
              if borders
                # With borders we handle padding separately
                "%#{maxima}s"
              elsif index == row_size - 1 # rubocop:disable Lint/DuplicateBranch
                # Don't output 2 trailing spaces when printing the last column
                "%#{maxima}s"
              else
                "%#{maxima}s  "
              end
            else
              adjust_for_ansi_codes @formats[index], column
            end

        cell = +""
        cell << "|#{" " * @padding}" if borders
        cell << (f % column.to_s)
        cell << (" " * @padding) if borders
        cell
      end

      def print_border_separator
        separator = @maximas.map do |maxima|
          "+#{"-" * (maxima + (2 * @padding))}"
        end
        stdout.puts "#{indentation}#{separator.join}+"
      end

      def truncate(string)
        return string unless @truncate

        chars = string.chars.to_a
        if chars.length <= @truncate
          chars.join
        else
          "#{chars[0, @truncate - 3 - @indent].join}..."
        end
      end

      def indentation
        " " * @indent
      end

      def adjust_for_ansi_codes(format, column)
        column_string = column.to_s
        if column_string =~ Shell::Color::ANSI_MATCH
          codes_count = column_string.scan(Shell::Color::ANSI_MATCH).sum do |match|
            match[0].length + 3
          end
          format.gsub(%r!(\d+)s!) do
            "#{Regexp.last_match[1].to_i + codes_count}s"
          end
        else
          format
        end
      end
    end
  end
end

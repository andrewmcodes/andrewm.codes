# frozen_string_literal: true

require_relative "empty_directory"

module Freyia
  module Automations
    # Create a new file relative to the destination root with the given data,
    # which is the return value of a block or a data string.
    #
    # @param destination [String] the relative path to the destination root.
    # @param data [String|NilClass] the data to append to the file.
    # @param config [Hash] give `verbose: false` to not log the status.
    #
    # @example Creating a file using a block
    #   create_file "lib/fun_party.rb" do
    #     hostname = ask("What is the virtual hostname I should use?")
    #     "vhost.name = #{hostname}"
    #   end
    #
    # @example Creating a file using a string
    #   create_file "config/apache.conf", "your apache config"
    def create_file(destination, data = nil, **config, &block)
      CreateFile.new(self, destination, block || data.to_s, **config).()
    end
    alias_method :add_file, :create_file

    # CreateFile is a subset of Template, which instead of rendering a file with
    # ERB, it gets the content from the user.
    class CreateFile < EmptyDirectory
      attr_reader :data

      def initialize(base, destination, data, **config)
        @data = data
        super(base, destination, **config)
      end

      # Checks if the content of the file at the destination is identical to the rendered result.
      #
      # @return [Boolean] true if it is identical, false otherwise.
      #
      def identical?
        # binread uses ASCII-8BIT, so to avoid false negatives, the string must use the same
        exists? && File.binread(destination) == String.new(render).force_encoding("ASCII-8BIT")
      end

      # Holds the content to be added to the file.
      #
      def render
        @render ||= data.is_a?(Proc) ? data.() : data
      end

      def call
        invoke_with_conflict_check do
          require "fileutils"
          FileUtils.mkdir_p(File.dirname(destination))
          File.open(destination, "wb", config[:perm]) { |f| f.write render }
        end
        given_destination
      end

      protected

      # Now on conflict we check if the file is identical or not.
      #
      def on_conflict_behavior(&)
        if identical?
          say_status :identical, :blue
        else
          options = base.options.merge(config)
          force_or_skip_or_conflict(options[:force], options[:skip], &)
        end
      end

      # If force is true, run the action, otherwise check if it's not being
      # skipped. If both are false, show the file_collision menu, if the menu
      # returns true, force it, otherwise skip.
      #
      def force_or_skip_or_conflict(force, skip, &)
        if force
          say_status :force, :yellow
          yield unless pretend?
        elsif skip
          say_status :skip, :yellow
        else
          say_status :conflict, :red
          force_or_skip_or_conflict(force_on_collision?, true, &)
        end
      end

      # Shows the file collision menu to the user and gets the result.
      #
      def force_on_collision?
        base.shell.file_collision(destination) { render }
      end
    end
  end
end

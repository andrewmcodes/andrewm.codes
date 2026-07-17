# frozen_string_literal: true

require_relative "create_file"

module Freyia
  module Automations
    # Create a new symbolic link relative to the destination root from the given source.
    #
    # @param destination [String] the relative path to the destination root.
    # @param source [String|NilClass] the relative path to the source root.
    # @param config [Hash] give `verbose: false` to not log the status.
    #   give `symbolic: false` for hard link.
    #
    # @example Creating a link
    #   create_link "config/apache.conf", "/etc/apache.conf"
    def create_link(destination, source, **config)
      CreateLink.new(self, destination, source, **config).()
    end
    alias_method :add_link, :create_link

    # CreateLink is a subset of CreateFile, which instead of taking a block of
    # data, just takes a source string from the user.
    class CreateLink < CreateFile
      attr_reader :data

      # Checks if the content of the file at the destination is identical to the rendered result.
      #
      # @return [Boolean] true if it is identical, false otherwise.
      def identical?
        source = File.expand_path(render, File.dirname(destination))
        exists? && File.identical?(source, destination)
      end

      def call
        invoke_with_conflict_check do
          require "fileutils"
          FileUtils.mkdir_p(File.dirname(destination))
          # Create a symlink by default
          config[:symbolic] = true if config[:symbolic].nil?
          File.unlink(destination) if exists?
          if config[:symbolic]
            File.symlink(render, destination)
          else
            File.link(render, destination)
          end
        end
        given_destination
      end

      def exists? = super || File.symlink?(destination)
    end
  end
end

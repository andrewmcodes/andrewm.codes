# frozen_string_literal: true

require_relative "empty_directory"

module Freyia
  module Automations
    # Copies recursively the files from source directory to root directory.
    # If any of the files finishes with `.tmpl`, it's considered to be a template
    # and is placed in the destination without the extension `.tmpl`. If any
    # empty directory is found, it's copied and all .empty_directory files are
    # ignored. If any file name is wrapped within `%` signs, the text within
    # the `%` signs will be executed as a method and replaced with the returned
    # value. Let's suppose a doc directory with the following files:
    #
    #   doc/
    #     components/.empty_directory
    #     README
    #     rdoc.rb.tmpl
    #     %app_name%.rb
    #
    # When invoked as:
    #
    #   directory "doc"
    #
    # It will create a doc directory in the destination with the following
    # files (assuming that the `app_name` method returns the value "blog"):
    #
    #   doc/
    #     components/
    #     README
    #     rdoc.rb
    #     blog.rb
    #
    # **Encoded path note:** Since Freyia internals use Object#respond_to? to check if it can
    # expand `%something%`, this `something` should be a public method in the class calling
    # `#directory`.
    #
    # @param source [String] the relative path to the source root.
    # @param destination [String] the relative path to the destination root.
    # @param config [Hash]
    #   * give `verbose: false` to not log the status.
    #   * `recursive: false`, does not look for paths recursively.
    #   * `mode: :preserve`, preserve the file mode from the source.
    #   * `exclude_pattern: /regexp/`, prevents copying files that match that regexp.
    #
    # @example Copy a directory verbatim
    #   directory "doc"
    # @example Copy a directory using a new name and no subdirectories
    #   directory "doc", "docs", recursive: false
    def directory(source, destination = nil, **config, &)
      Directory.new(self, source, destination, **config, &).()
    end

    class Directory < EmptyDirectory
      attr_reader :source

      def initialize(base, source, destination = source, **config, &block)
        @source = File.expand_path(
          Dir[Automations.escape_globs(base.find_in_source_paths(source.to_s))].first
        )
        @block = block
        super(base, destination, recursive: true, **config)
      end

      def call
        base.empty_directory given_destination, **config
        execute!
      end

      protected

      def execute! # rubocop:todo Metrics
        lookup = Automations.escape_globs(source)
        lookup = File.join(lookup, "**") if config[:recursive]
        lookup = file_level_lookup(lookup)

        files(lookup).sort.each do |file_source|
          next if File.directory?(file_source)
          next if config[:exclude_pattern] && file_source.match(config[:exclude_pattern])

          file_destination = File.join(given_destination, file_source.gsub(source, "."))
          file_destination.gsub!("/./", "/")

          case file_source
          when %r{\.empty_directory$}
            dirname = File.dirname(file_destination).gsub(%r{/\.$}, "")
            next if dirname == given_destination

            base.empty_directory(dirname, **config)
          when %r{#{TEMPLATE_EXTNAME}$}o
            base.template(file_source, file_destination[0..-4], **config, &@block)
          else
            base.copy_file(file_source, file_destination, **config, &@block)
          end
        end
      end

      def file_level_lookup(previous_lookup)
        File.join(previous_lookup, "*")
      end

      def files(lookup)
        Dir.glob(lookup, File::FNM_DOTMATCH)
      end
    end
  end
end

# frozen_string_literal: true

require_relative "empty_directory"

module Freyia
  module Automations
    WARNINGS = {
      unchanged_no_flag: "File unchanged! Either the supplied flag value not found or the " \
                         "content has already been inserted!",
    }.freeze

    # Injects the given content into a file, raising an error if the contents of
    # the file are not changed.
    #
    # @param destination [String] Relative path to the destination root
    # @param data [String] Data to add to the file. Can be given as a block.
    # @param config [Hash] give `verbose: false` to not log the status and the flag
    #   for injection (`after:` or `before:`) or `force: true` for
    #   inserting the same content multiple times.
    #
    # @example Inserting text after a match
    #   insert_into_file! "config/environment.rb", "config.gem :freyia",
    #                     after: "Rails::Initializer.run do |config|\n"
    #
    # @example Inserting text based on input within a block
    #   insert_into_file! "config/environment.rb", after: "Rails::Initializer.run do |config|\n" do
    #     gems = ask "Which gems would you like to add?"
    #     gems.split(" ").map{ |gem| "  config.gem :#{gem}" }.join("\n")
    #   end
    def insert_into_file!(destination, *args, **config, &block)
      data = block_given? ? block : args.shift

      config[:after] = %r{\z} unless config.key?(:before) || config.key?(:after)

      InjectIntoFile.new(self, destination, data, error_on_no_change: true, **config).()
    end
    alias_method :inject_into_file!, :insert_into_file!

    # Injects the given content into a file.
    #
    # @param destination [String] Relative path to the destination root
    # @param data [String] Data to add to the file. Can be given as a block.
    # @param config [Hash] give `verbose: false` to not log the status and the flag
    #   for injection (`after:` or `before:`) or `force: true` for
    #   inserting the same content multiple times.
    #
    # @example Inserting text after a match
    #   insert_into_file "config/environment.rb", "config.gem :freyia",
    #                    after: "Rails::Initializer.run do |config|\n"
    #
    # @example Inserting text based on input within a block
    #   insert_into_file "config/environment.rb", after: "Rails::Initializer.run do |config|\n" do
    #     gems = ask "Which gems would you like to add?"
    #     gems.split(" ").map{ |gem| "  config.gem :#{gem}" }.join("\n")
    #   end
    def insert_into_file(destination, *args, **config, &block)
      data = block_given? ? block : args.shift

      config[:after] = %r{\z} unless config.key?(:before) || config.key?(:after)

      InjectIntoFile.new(self, destination, data, **config).()
    end
    alias_method :inject_into_file, :insert_into_file

    class InjectIntoFile < EmptyDirectory
      attr_reader :replacement, :flag, :behavior

      def initialize(base, destination, data, **config)
        super(base, destination, verbose: true, **config)

        @behavior, @flag = if @config.key?(:after)
                             [:after, @config.delete(:after)]
                           else
                             [:before, @config.delete(:before)]
                           end

        @replacement = data.is_a?(Proc) ? data.() : data
        @flag = Regexp.escape(@flag) unless @flag.is_a?(Regexp)
        @error_on_no_change = @config.fetch(:error_on_no_change, false)
      end

      def call # rubocop:todo Metrics
        content = if @behavior == :after
                    "\\0#{replacement}"
                  else
                    "#{replacement}\\0"
                  end

        if exists?
          if replace!(%r{#{flag}}, content, config[:force])
            say_status(:invoke)
          elsif @error_on_no_change
            raise Freyia::Error, "The content of #{destination} did not change"
          elsif replacement_present?
            say_status(:unchanged, color: :blue)
          else
            say_status(:unchanged, warning: WARNINGS[:unchanged_no_flag], color: :red)
          end
        else
          raise Freyia::Error, "The file #{destination} does not appear to exist" unless pretend?
        end
      end

      protected

      def say_status(behavior, warning: nil, color: nil) # rubocop:todo Metrics
        status = if behavior == :invoke
                   if flag == %r{\A}
                     :prepend
                   elsif flag == %r{\z}
                     :append
                   else
                     :insert
                   end
                 elsif warning
                   warning
                 elsif behavior == :unchanged
                   :unchanged
                 else
                   :subtract
                 end

        super(status, color || config[:verbose])
      end

      def content
        @content ||= File.read(destination)
      end

      def replacement_present?
        content.include?(replacement)
      end

      # Adds the content to the file.
      def replace!(regexp, string, force)
        return unless force || !replacement_present?

        success = content.gsub!(regexp, string)

        File.binwrite(destination, content) unless pretend?
        success
      end
    end
  end
end

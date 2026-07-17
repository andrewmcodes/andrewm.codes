# frozen_string_literal: true

require_relative "automations/create_file"
require_relative "automations/create_link"
require_relative "automations/directory"
require_relative "automations/empty_directory"
require_relative "automations/file_manipulation"
require_relative "automations/inject_into_file"

module Freyia
  module Automations
    # Returns a string that has had any glob characters escaped.
    # The glob characters are `* ? { } [ ]`.
    #
    # @example
    #   Freya::Automations.escape_globs('[apps]')   # => '\[apps\]'
    #
    # @param path [String]
    # @return [String]
    def self.escape_globs(path)
      path.to_s.gsub(%r{[*?{}\[\]]}, '\\\\\\&')
    end

    # Returns the root for this freyia class (also aliased as destination root).
    #
    def destination_root
      @destination_stack.last
    end

    # Sets the root for this freyia class. Relatives path are added to the
    # directory where the script was invoked and expanded.
    #
    def destination_root=(root)
      @destination_stack ||= []
      @destination_stack[0] = File.expand_path(root || "")
    end

    # Returns the given path relative to the absolute root (ie, root where
    # the script started).
    #
    def relative_to_original_destination_root(path, remove_dot: true)
      root = @destination_stack[0]
      if path.start_with?(root) && [File::SEPARATOR, File::ALT_SEPARATOR, nil,
                                    "",].include?(path[root.size..root.size])
        path = path.dup
        path[0...root.size] = "."
        remove_dot ? (path[2..] || "") : path
      else
        path
      end
    end

    # Receives a file or directory and search for it in the source paths.
    #
    def find_in_source_paths(file)
      possible_files = [file, file + TEMPLATE_EXTNAME]
      relative_root = relative_to_original_destination_root(destination_root, remove_dot: false)

      source_paths.each do |source|
        possible_files.each do |f|
          source_file = File.expand_path(f, File.join(source, relative_root))
          return source_file if File.exist?(source_file)
        end
      end

      message = "Could not find #{file.inspect} in any of your source paths. "

      message << if source_paths.empty?
                   "Currently you have no source paths."
                 else
                   "Your current source paths are: \n#{source_paths.join("\n")}"
                 end

      raise Error, message
    end

    # Do something in the root or on a provided subfolder. If a relative path
    # is given it's referenced from the current root. The full path is yielded
    # to the block you provide. The path is set back to the previous path when
    # the method exits.
    #
    # Returns the value yielded by the block.
    #
    # ==== Parameters
    # dir<String>:: the directory to move to.
    # config<Hash>:: give :verbose => true to log and use padding.
    #
    def inside(dir = "", verbose: false, &block) # rubocop:todo Metrics
      pretend = options[:pretend]

      say_status :inside, dir, verbose
      shell.padding += 1 if verbose
      @destination_stack.push File.expand_path(dir, destination_root)

      # If the directory doesn't exist and we're not pretending
      if !File.exist?(destination_root) && !pretend
        require "fileutils"
        FileUtils.mkdir_p(destination_root)
      end

      result = nil
      if pretend
        # In pretend mode, just yield down to the block
        result = block.arity == 1 ? yield(destination_root) : yield
      else
        require "fileutils"
        FileUtils.cd(destination_root) do
          result = block.arity == 1 ? yield(destination_root) : yield
        end
      end

      @destination_stack.pop
      shell.padding -= 1 if verbose
      result
    end

    # Goes to the root and execute the given block.
    #
    def in_root(&)
      inside(@destination_stack.first, &)
    end

    # Loads an external file and execute it in the instance binding.
    #
    # ==== Parameters
    # path<String>:: The path to the file to execute. Can be a web address or
    #                a relative path from the source root.
    #
    # ==== Examples
    #
    #   apply "http://gist.github.com/103208"
    #
    #   apply "recipes/jquery.rb"
    #
    def apply(path, verbose: true)
      is_uri  = path =~ %r{^https?://}
      path    = find_in_source_paths(path) unless is_uri

      say_status :apply, path, verbose
      shell.padding += 1 if verbose

      contents = if is_uri
                   require "open-uri"
                   URI.open(path, "Accept" => "application/x-freyia-template", &:read) # rubocop:disable Security/Open
                 else
                   File.read(path)
                 end

      instance_eval(contents, path)
      shell.padding -= 1 if verbose
    end

    # Executes a command returning the contents of the command.
    #
    # ==== Parameters
    # command<String>:: the command to be executed.
    # config<Hash>:: give :verbose => false to not log the status, :capture => true to hide to
    #                output. Specify :with to append an executable to command execution.
    #
    # ==== Example
    #
    #   inside('vendor') do
    #     run('ln -s ~/edge rails')
    #   end
    #
    def run(command, **config) # rubocop:todo Metrics
      destination = relative_to_original_destination_root(destination_root, remove_dot: false)
      desc = "#{command} from #{destination.inspect}"

      if config[:with]
        desc = "#{File.basename(config[:with].to_s)} #{desc}"
        command = "#{config[:with]} #{command}"
      end

      say_status :run, desc, config.fetch(:verbose, true)

      return if options[:pretend]

      env_splat = [config[:env]] if config[:env]

      if config[:capture]
        require "open3"
        result, status = Open3.capture2e(*env_splat, command.to_s)
        success = status.success?
      else
        result = system(*env_splat, command.to_s)
        success = result
      end

      abort if !success &&
        config.fetch(:abort_on_failure,
                     self.class.respond_to?(:exit_on_failure?) && self.class.exit_on_failure?)

      result
    end
  end
end

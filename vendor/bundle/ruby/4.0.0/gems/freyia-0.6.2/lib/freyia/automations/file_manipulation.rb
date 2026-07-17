# frozen_string_literal: true

require "erb"

module Freyia
  module Automations
    # Copies the file from the relative source to the relative destination. If
    # the destination is not given it's assumed to be equal to the source.
    #
    # @param source [String] the relative path to the source root.
    # @param destination [String] the relative path to the destination root.
    # @param config [Hash] give `verbose: false` to not log the status, and
    #   `mode: :preserve`, to preserve the file mode from the source.
    #
    # @example Copy a file to a new destination
    #   copy_file "README", "doc/README"
    # @example Copy a file straight from source to destination
    #   copy_file "doc/README"
    def copy_file(source, destination = source, **config, &block)
      source = File.expand_path(find_in_source_paths(source.to_s))

      resulting_destination = create_file destination, nil, **config do
        content = File.binread(source)
        content = yield(content) if block
        content
      end
      return unless config[:mode] == :preserve

      mode = File.stat(source).mode
      chmod(resulting_destination, mode, **config)
    end

    # Links the file from the relative source to the relative destination. If
    # the destination is not given it's assumed to be equal to the source.
    #
    # @param source [String] the relative path to the source root.
    # @param destination [String] the relative path to the destination root.
    # @param config [Hash] give :verbose => false to not log the status.
    #
    # @example Link a file to a new destination
    #   link_file "README", "doc/README"
    # @example Link a file straight from source to destination
    #   link_file "doc/README"
    def link_file(source, destination = source, **config)
      source = File.expand_path(find_in_source_paths(source.to_s))

      create_link destination, source, **config
    end

    # Gets the content at the given address and places it at the given relative
    # destination. If a block is given instead of destination, the content of
    # the url is yielded and used as location.
    #
    # `get` relies on open-uri, so passing application user input would provide
    # a command injection attack vector.
    #
    # @param source [String] the address of the given content.
    # @param destination [String] the relative path to the destination root.
    # @param config [Hash] give `verbose: false` to not log the status, and
    #   `http_headers: <Hash>` to add headers to an http request.
    # @example Create files from remote URLs
    #   get "http://gist.github.com/103208", "doc/README"
    #
    #   get "http://gist.github.com/103208", "doc/README", :http_headers => {"Content-Type" => "application/json"}
    # @example Use a block to modify the remote content
    #   get "http://gist.github.com/103208" do |content|
    #     content.split("\n").first
    #   end
    def get(source, destination = nil, **config, &block)
      render = if %r{^https?://}.match?(source)
                 require "open-uri"
                 URI.send(:open, source, config.fetch(:http_headers, {})) do |input|
                   input.binmode.read
                 end
               else
                 source = File.expand_path(find_in_source_paths(source.to_s))
                 File.open(source) { |input| input.binmode.read }
               end

      destination ||= if block_given?
                        block.arity == 1 ? yield(render) : yield
                      else
                        File.basename(source)
                      end

      create_file destination, render, **config
    end

    # Gets an ERB template at the relative source, executes it and makes a copy
    # at the relative destination. If the destination is not given it's assumed
    # to be equal to the source removing `.tmpl` from the filename.
    #
    # @param source [String] the relative path to the source root.
    # @param destination [String] the relative path to the destination root.
    # @param context [Binding] if you want access to local variables from the caller
    # @param type [Symbol] to use a template type that differs from the default,
    #   specify here (`:erb` or `:serbea`)
    # @param config [Hash] give `verbose: false` to not log the status.
    #
    # @example Process `README.tmpl` and save to a new destination
    #   template "README", "doc/README"
    # @example Process from source and save to destination
    #   template "doc/README"
    def template(source, destination = nil, context: nil, type: nil, **config, &block) # rubocop:todo Metrics
      destination ||= source.sub(%r{#{TEMPLATE_EXTNAME}$}o, "")
      source = File.expand_path(find_in_source_paths(source.to_s))
      type ||= self.class.template_type

      create_file destination, nil, **config do
        if type == :serbea
          unless @_included_serbea
            require "serbea"
            singleton_class.include Serbea::Helpers
            @_included_serbea = true
          end

          variables = if context
                        context.local_variables.to_h { [_1, context.local_variable_get(_1)] }
                      else
                        {}
                      end
          tmpl = Tilt::SerbeaTemplate.new(source, strip_front_matter: false) { ::File.binread(source) }
          tmpl.render(self, variables)
        elsif type == :erb
          context ||= instance_eval("binding", __FILE__, __LINE__)
          capturable_erb = CapturableERB.new(
            ::File.binread(source), trim_mode: "-", eoutvar: "@output_buffer"
          )
          content = capturable_erb.tap do |erb|
            erb.filename = source
          end.result(context)
          content = yield(content) if block
          content
        end
      end
    end

    # Changes the mode of the given file or directory.
    #
    # @param mode [Integer] the file mode
    # @param path [String] the name of the file to change mode
    # @param config [Hash] give `verbose: false` to not log the status.
    #
    # @example Update mode of the destination file `script/server`
    #   chmod "script/server", 0755
    def chmod(path, mode, **config)
      path = File.expand_path(path, destination_root)
      say_status :chmod, relative_to_original_destination_root(path), config.fetch(:verbose, true)
      return if options[:pretend]

      require "fileutils"
      FileUtils.chmod_R(mode, path)
    end

    # Prepend text to a file.
    #
    # @param path [String] path of the file to be changed
    # @param data [String] the data to prepend to the file, can be also given as a block.
    # @param config [Hash] give `verbose: false` to not log the status.
    #
    # @example Prepend destination file with a string
    #   prepend_to_file 'config/environments/test.rb', 'config.gem "rspec"'
    # @example Prepend destination file with results of block
    #   prepend_to_file 'config/environments/test.rb' do
    #     'config.gem "rspec"'
    #   end
    def prepend_to_file(path, *, **config, &)
      config[:after] = %r{\A}
      insert_into_file(path, *, **config, &)
    end
    alias_method :prepend_file, :prepend_to_file

    # Append text to a file.
    #
    # @param path [String] path of the file to be changed
    # @param data [String] the data to append to the file, can be also given as a block.
    # @param config [Hash] give `verbose: false` to not log the status.
    #
    # @example Prepend destination file with a string
    #   append_to_file 'config/environments/test.rb', 'config.gem "rspec"'
    # @example Prepend destination file with results of block
    #   append_to_file 'config/environments/test.rb' do
    #     'config.gem "rspec"'
    #   end
    def append_to_file(path, *, **config, &)
      config[:before] = %r{\z}
      insert_into_file(path, *, **config, &)
    end
    alias_method :append_file, :append_to_file

    # Injects text right after the class definition.
    #
    # @param path [String] path of the file to be changed
    # @param klass [String|Class] the class to be manipulated
    # @param data [String] the data to append to the class, can be also given as a block.
    # @param config [Hash] give `verbose: false` to not log the status.
    #
    # @example Inject class using provided string
    #   inject_into_class "app/controllers/application_controller.rb",
    #                     "ApplicationController",
    #                     "  filter_parameter :password\n"
    #
    # @example Inject class using result from block
    #   inject_into_class "app/controllers/application_controller.rb", "ApplicationController" do
    #     "  filter_parameter :password\n"
    #   end
    def inject_into_class(path, klass, *, **config, &)
      config[:after] = %r{class #{klass}\n|class #{klass} .*\n}
      insert_into_file(path, *, **config, &)
    end

    # Injects text right after the module definition.
    #
    # @param path [String] path of the file to be changed
    # @param module_name [String|Class] the module to be manipulated
    # @param data [String] the data to append to the class, can be also given as a block.
    # @param config [Hash] give :verbose => false to not log the status.
    #
    # @example Inject module using provided string
    #   inject_into_module "app/helpers/application_helper.rb",
    #                      "ApplicationHelper",
    #                      "  def help; 'help'; end\n"
    #
    # @example Inject module using result from block
    #   inject_into_module "app/helpers/application_helper.rb", "ApplicationHelper" do
    #     "  def help; 'help'; end\n"
    #   end
    def inject_into_module(path, module_name, *, **config, &)
      config[:after] = %r{module #{module_name}\n|module #{module_name} .*\n}
      insert_into_file(path, *, **config, &)
    end

    # Run a regular expression replacement on a file, raising an error if the
    # contents of the file are not changed.
    #
    # @param path [String] path of the file to be changed
    # @param flag [Regexp|String] the regexp or string to be replaced
    # @param replacement [String] the replacement, can be also given as a block
    # @param config [Hash] give `verbose: false` to not log the status, and
    #                           `force: true`, to force the replacement regardless of behavior.
    #
    # @example Modify destination file
    #   gsub_file! 'app/controllers/application_controller.rb',
    #              /#\s*(filter_parameter_logging :password)/, '\1'
    def gsub_file!(path, flag, *args, verbose: true, &)
      path = File.expand_path(path, destination_root)
      say_status :gsub, relative_to_original_destination_root(path), verbose

      actually_gsub_file(path, flag, args, true, &) unless options[:pretend]
    end

    # Run a regular expression replacement on a file.
    #
    # @param path [String] path of the file to be changed
    # @param flag [Regexp|String] the regexp or string to be replaced
    # @param replacement [String] the replacement, can be also given as a block
    # @param config [Hash] give `verbose: false` to not log the status, and
    #                           `force: true`, to force the replacement regardless of behavior.
    #
    # @example Modify destination file
    #   gsub_file 'app/controllers/application_controller.rb',
    #             /#\s*(filter_parameter_logging :password)/, '\1'
    def gsub_file(path, flag, *args, verbose: true, &)
      path = File.expand_path(path, destination_root)
      say_status :gsub, relative_to_original_destination_root(path), verbose

      actually_gsub_file(path, flag, args, false, &) unless options[:pretend]
    end

    # Uncomment all lines matching a given regex. Preserves indentation before
    # the comment hash and removes the hash and any immediate following space.
    #
    # @param path [String] path of the file to be changed
    # @param flag [Regexp|String] the regexp or string used to decide which lines to uncomment
    #
    # @example Uncomment the lines which match the pattern
    #   uncomment_lines 'config/initializers/session_store.rb', /active_record/
    def uncomment_lines(path, flag)
      flag = flag.source if flag.respond_to?(:source)

      gsub_file(path, %r{^(\s*)#[[:blank:]]?(.*#{flag})}, '\1\2')
    end

    # Comment all lines matching a given regex.  It will leave the space
    # which existed before the beginning of the line in tact and will insert
    # a single space after the comment hash.
    #
    # @param path [String] path of the file to be changed
    # @param flag [Regexp|String] the regexp or string used to decide which lines to comment
    #
    # @example Comment lines which match the pattern
    #   comment_lines 'config/initializers/session_store.rb', /cookie_store/
    def comment_lines(path, flag)
      flag = flag.source if flag.respond_to?(:source)

      gsub_file(path, %r{^(\s*)([^#\n]*#{flag})}, '\1# \2')
    end

    # Removes a file at the given location.
    #
    # @param path [String] path of the file to be changed
    # @param config [Hash] give `verbose: false` to not log the status.
    #
    # @example Removing files
    #   remove_file 'README'
    #   remove_file 'app/controllers/application_controller.rb'
    def remove_file(path, verbose: true)
      path = File.expand_path(path, destination_root)

      say_status :remove, relative_to_original_destination_root(path), verbose
      return unless !options[:pretend] && (File.exist?(path) || File.symlink?(path))

      require "fileutils"
      ::FileUtils.rm_rf(path)
    end
    alias_method :remove_dir, :remove_file

    attr_accessor :output_buffer
    private :output_buffer, :output_buffer=

    private

    def concat(string)
      @output_buffer.concat(string)
    end

    def capture(*args)
      with_output_buffer { yield(*args) }
    end

    def with_output_buffer(buf = +"")
      raise ArgumentError, "Buffer cannot be a frozen object" if buf.frozen?

      old_buffer = output_buffer
      self.output_buffer = buf
      yield
      output_buffer
    ensure
      self.output_buffer = old_buffer
    end

    def actually_gsub_file(path, flag, args, error_on_no_change, &)
      content = File.binread(path)
      success = content.gsub!(flag, *args, &)

      if success.nil? && error_on_no_change
        raise Freyia::Error, "The content of #{path} did not change"
      end

      File.binwrite(path, content)
    end

    # Freyia::Automations#capture depends on what kind of buffer is used in ERB.
    # Thus CapturableERB fixes ERB to use String buffer.
    class CapturableERB < ERB
      def set_eoutvar(compiler, eoutvar = "_erbout")
        compiler.put_cmd = "#{eoutvar}.concat"
        compiler.insert_cmd = "#{eoutvar}.concat"
        compiler.pre_cmd = ["#{eoutvar} = ''.dup"]
        compiler.post_cmd = [eoutvar]
      end
    end
  end
end

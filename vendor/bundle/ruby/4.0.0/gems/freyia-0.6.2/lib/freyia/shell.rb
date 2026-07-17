# frozen_string_literal: true

require "rbconfig"

module Freyia
  module Shell
    SHELL_DELEGATED_METHODS = [:ask, :error, :set_color, :yes?, :no?, :say, :say_error,
                               :say_status, :print_in_columns, :print_table, :print_wrapped,
                               :file_collision, :terminal_width,].freeze

    autoload :Basic, File.expand_path("shell/basic", __dir__)
    autoload :Color, File.expand_path("shell/color", __dir__)
    # Common methods that are delegated to the shell.
    SHELL_DELEGATED_METHODS.each do |method|
      module_eval <<-METHOD, __FILE__, __LINE__ + 1 # rubocop:disable Style/DocumentDynamicEvalDefinition
        def #{method}(*args, **kwargs, &block)
          shell.#{method}(*args, **kwargs, &block)
        end
      METHOD
    end

    # Yields the given block with padding.
    def with_padding
      shell.padding += 1
      yield
    ensure
      shell.padding -= 1
    end
  end
end

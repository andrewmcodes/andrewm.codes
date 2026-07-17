# frozen_string_literal: true

require_relative "freyia/version"

module Freyia
  class Error < StandardError; end

  TEMPLATE_EXTNAME = ".tmpl"
end

require_relative "freyia/shell"
require_relative "freyia/automations"
require_relative "freyia/line_editor"

module Freyia::Setup
  include Freyia::Shell
  include Freyia::Automations

  module ClassMethods
    # Returns the shell used in all Freyia classes. If you are in a Unix platform
    # it will use a colored log, otherwise it will use a basic one without color.
    #
    def shell
      @shell ||= if ENV["FREYIA_SHELL"] && !ENV["FREYIA_SHELL"].empty?
                   Freyia::Shell.const_get(ENV["FREYIA_SHELL"])
                 elsif RbConfig::CONFIG["host_os"] =~ %r{mswin|mingw} && !ENV["ANSICON"]
                   Freyia::Shell::Basic
                 else
                   Freyia::Shell::Color
                 end
    end

    # Set or return the `template` type for the Freyia base. Defaults to `:erb`
    #
    # @param type [Symbol] either `:erb` or `:serbea`
    # @return [Symbol] if called without an argument, returns the template type
    def template_type(type = nil)
      @template_type ||= :erb
      type ? @template_type = type : @template_type
    end
  end

  def self.included(klass)
    klass.attr_accessor :source_paths
    klass.extend ClassMethods
  end

  def shell
    @shell ||= self.class.shell.new(base: self)
  end

  def options
    @options ||= {}
  end
end

class Freyia::Base
  include Freyia::Setup

  def initialize(source:, dest:)
    self.source_paths = Array(source).map { File.expand_path(_1, Dir.pwd) }
    self.destination_root = File.expand_path(dest, Dir.pwd)
  end
end

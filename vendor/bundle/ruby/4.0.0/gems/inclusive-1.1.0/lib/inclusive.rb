# frozen_string_literal: true

require "set"

require_relative "inclusive/version"

# Include this in any class so you have access to the `packages` method (both class and instance).
module Inclusive
  # You can extend a module with this in order to use `public_function`, which is the same as
  # Ruby's native `module_function` except the instance method retains public visibility—a necessity
  # for packaging via Inclusive.
  module Public
    def public_function(method_name)
      module_function method_name
      public method_name # reset back to public visibility
    end
  end

  extend Inclusive::Public

  # This is the base module which will be cloned for each individual import scenario. You should
  # never need to reference this module directly.
  module ModuleWithPackages
    # Use this for the inline packages syntax.
    #
    # @example importing packages
    #   utils = packages[UtilitiesPackage, Another::Package]
    #   utils.make_it(:so)
    def self.[](*packages)
      packages.each { |package| extend_with_package(package) }
      self
    end

    def self.extend_with_package(package)
      @package_names ||= Set.new
      @package_methods ||= Set.new

      warn_on_overwritten_methods(package)
      package.instance_methods.each { @package_methods << _1 }
      @package_names << package.name

      extend package
    end

    def self.warn_on_overwritten_methods(package)
      overwriting_methods = @package_methods.select { package.instance_methods.include? _1 }
      return unless overwriting_methods.length.positive?

      warn "Inclusive <#{@package_names.join(", ")}> - The following methods will be overridden by " \
           "'#{package.name}':\n  #{overwriting_methods.join(", ")}"
    end

    def self.to_s = "#{name}<#{@package_names.join(", ")}>"

    def self.inspect = to_s

    def self.loaded_packages
      singleton_class.included_modules.reverse.select { @package_names.include? _1.name }
    end

    def self.package_methods
      loaded_packages.flat_map(&:instance_methods)
    end
  end

  # This will extend your class by default if you `include Inclusive`, but if for some reason you
  # don't want the `packages` instance method in your class, you can simply
  # `extend Inclusive::Class`
  module Class
    # Use this as a decorator for an instance method which you will use to access your package
    # imports.
    #
    # @example method definition
    #   packages def utilities = [Package1, Package2]
    #
    #   def some_logic_here
    #     utilities.do_stuff # from Package1
    #     utilities.convert(x) # from Package2
    #   end
    #
    # This new method will be set to private, unless you use `public_packages` instead of `packages`.
    #
    # @return [void]
    def packages(method_name)
      old_method_name = :"__old_#{method_name}__"
      ivar_name = :"@_#{method_name}"

      alias_method old_method_name, method_name

      define_method method_name do
        return instance_variable_get(ivar_name) if instance_variable_defined?(ivar_name)

        packages_to_extend = send(old_method_name)
        ModuleWithPackages.dup.tap do |mod|
          mod.module_eval do
            def self.name = "ModuleWithPackages" # preserve module name
          end
          packages_to_extend.each { |package| mod.extend_with_package(package) }
          instance_variable_set(ivar_name, mod)
        end
      end

      private method_name unless __callee__ == :public_packages
    end

    alias public_packages packages
  end

  def self.included(klass)
    klass.extend self::Class
  end

  # Returns a blank module ready for package imports, useful for inline package access when an
  # instance method is not suitable (perhaps you're in a template or block context).
  #
  # @return [ModuleWithPackages]
  def packages = ModuleWithPackages.dup.tap do |mod|
    mod.module_eval do
      def self.name = "ModuleWithPackages" # preserve module name
    end
  end

  public_function :packages
end

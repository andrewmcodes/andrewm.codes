# frozen_string_literal: true

require "tilt/erubi"

module Streamlined
  module Helpers
    module TouchableProc
      attr_accessor :__streamlined_touched

      def self.run_through_pipeline(in_context_binding, input, callback)
        Serbea::Pipeline.new(in_context_binding, input).tap { _1.instance_exec(&callback) }.then do |pipeline|
          -> { pipeline.value }
        end
      end

      def __streamlined_touch
        self.__streamlined_touched = true
        self
      end

      def html_safe
        @html_safe = true
        self
      end

      def html_safe?
        @html_safe == true
      end

      def to_s
        return self.().to_s.then { html_safe? ? _1.html_safe : _1 } if __streamlined_touched

        super
      end

      def encode(...)
        to_s.encode(...)
      end
    end

    ::Proc.prepend(TouchableProc)

    # Create a set of attributes from a hash.
    #
    # @param options [Hash] key-value pairs of HTML attributes (or use keyword arguments)
    # @param prefix_space [Boolean] add a starting space if attributes are present,
    #   useful in tag builders
    # @return [String]
    def html_attributes(options = nil, prefix_space: false, **kwargs) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      options ||= kwargs
      segments = []
      options.each do |attr, option|
        next if option == false || option.nil?

        attr = dashed(attr)
        if option.is_a?(Hash)
          option = option.transform_keys { |key| "#{attr}-#{dashed(key)}" }
          segments << html_attributes(option)
        else
          segments << attribute_segment(attr, option)
        end
      end
      segments.join(" ").then do |output|
        prefix_space && !output.empty? ? " #{output}" : output
      end
    end

    # Covert an underscored value into a dashed string.
    #
    # @example "foo_bar_baz" => "foo-bar-baz"
    #
    # @param value [String|Symbol]
    # @return [String]
    def dashed(value)
      value.to_s.tr("_", "-")
    end

    # Create an attribute segment for a tag.
    #
    # @param attr [String] the HTML attribute name
    # @param value [String] the attribute value
    # @return [String]
    def attribute_segment(attr, value)
      "#{attr}=\"#{CGI.escapeHTML(value.to_s)}\""
    end

    def text(callback, piping = nil)
      callback = TouchableProc.run_through_pipeline(binding, callback, piping) if piping

      (callback.is_a?(Proc) ? callback.__streamlined_touch : callback).to_s.then do |str|
        next str if str.html_safe?

        CGI.escapeHTML(str)
      end
    end

    def html(callback, piping = nil)
      callback = TouchableProc.run_through_pipeline(binding, callback, piping) if piping

      callback.html_safe.__streamlined_touch
    end

    def html_map(input, &callback)
      input.map(&callback).join
    end
  end
end

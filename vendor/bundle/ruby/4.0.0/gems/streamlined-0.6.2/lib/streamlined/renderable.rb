# frozen_string_literal: true

module Streamlined
  module Renderable
    include Streamlined::Helpers

    class OutputBuffer < String
      def initialize
        super
        @html_safe = true
      end
    end

    def render_in(view_context, &block)
      @_view_context = view_context
      template(&block).to_s.strip
    end

    def render(item = nil, **options, &block) # rubocop:disable Metrics
      return @_rbout if !block && options.empty? && item.nil?

      if item.is_a?(Proc) || (block && item.nil?)
        result = item.is_a?(Proc) ? item.to_s : yield
        return result if result.is_a?(OutputBuffer)

        result = text(result) if result.is_a?(String) && !result.html_safe?

        @_rbout ||= OutputBuffer.new
        @_rbout << result.to_s

        return @_rbout
      end

      if item.respond_to?(:render_in)
        result = item.render_in(self, &block)
        result&.to_s&.html_safe
      else
        raise Error, "You must implement a `partial' implementation yourself" unless respond_to?(:partial)

        partial(item, **options, &block)&.html_safe
      end
    end

    def helpers
      @_view_context
    end

    def capture(*args, &block)
      helpers ? helpers.capture(*args, &block) : yield(*args)
    end
  end
end

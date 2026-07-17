# frozen_string_literal: true

class Roda
  module RodaPlugins
    module Streamlined
      module CheckForStreamlined
        def self.===(other)
          other.is_a?(Proc) && other.respond_to?(:__streamlined_touched) && other.__streamlined_touched
        end
      end

      module InstanceMethods
        include ::Streamlined::Helpers
      end

      def self.load_dependencies(app, _opts = OPTS)
        app.plugin :custom_block_results
      end

      def self.configure(app, _opts = OPTS)
        app.handle_block_result CheckForStreamlined, &:to_s
      end
    end

    register_plugin :streamlined, Streamlined
  end
end

# frozen_string_literal: true

require "tilt"
require "tilt/erubi"
require "erubi/capture_block"

module Serbea
  class Error < StandardError; end

  class FilterMissing < Error; end
end

require "serbea/helpers"
require "serbea/pipeline"
require "serbea/template_engine"

module Tilt
  class SerbeaTemplate < ErubiTemplate
    def prepare
      @options.merge!(
        outvar: "@_erbout",
        bufval: "Serbea::OutputBuffer.new",
        literal_prefix: "{%",
        literal_postfix: "%}",
        engine_class: Serbea::TemplateEngine
      )
      super
    end

    def encoding
      @src.encoding
    end
  end
end

Tilt.register Tilt::SerbeaTemplate, "serb"

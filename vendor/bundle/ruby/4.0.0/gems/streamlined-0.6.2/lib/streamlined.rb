# frozen_string_literal: true

require "cgi/escape"
require "serbea/helpers" # primarily just for HTML safety polyfill
require "serbea/pipeline"
require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/roda")
loader.setup

module Streamlined
  class Error < StandardError; end
end

if defined?(Bridgetown) && Bridgetown.respond_to?(:initializer)
  Bridgetown.initializer :streamlined do |config|
    config.roda do |app|
      app.plugin :streamlined
    end
  end
end

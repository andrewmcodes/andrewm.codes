# frozen_string_literal: true

module BridgetownSvgInliner
  class LiquidAttributes
    attr_reader :path, :args

    def initialize(attributes)
      path, args = attributes.split(",", 2)

      @path = unescape_string(path)
      @args = args.scan(%r{([a-zA-Z0-9_-]+)\s*:\s*(#{Liquid::QuotedFragment})}o).map do |arg|
        [arg[0], unescape_string(arg[1])]
      end.to_h if args&.length&.positive?
    end

    private

    def unescape_string(string)
      string.undump
    rescue # rubocop:disable Style/RescueStandardError
      string
    end
  end
end

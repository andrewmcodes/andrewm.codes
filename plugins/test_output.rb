module TestOutput
  unless Bridgetown.env.development?
    Bridgetown::Hooks.register_one :site, :post_write do
      # Load test suite to run on exit
      require "nokogiri"
      Dir["test/**/*.rb"].each { |file| require_relative("../#{file}") }
    rescue LoadError
      Bridgetown.logger.warn "Testing:", "To run tests, you must first run `bundle install --with test`"
    end
  end
end

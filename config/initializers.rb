Bridgetown.configure do |config|
  require "bridgetown-svg-inliner"
  require "bridgetown-sitemap"
  require "bridgetown-view-component"
  require "rails/engine"
  # You can configure aspects of your Bridgetown site here instead of using
  # `bridgetown.config.yml`. For example:
  #
  # permalink "simple"
  timezone "America/Phoenix"
  template_engine "erb"
  highlighter ""

  #
  # You can also modify options on the configuration object directly, like so:
  #
  # config.autoload_paths << "models"
  #

  # You can use `init` to initialize various Bridgetown features or plugin gems.

  init :dotenv
  init :"bridgetown-feed"

  # Uncomment to use Bridgetown SSR (aka dynamic rendering of content via Roda):
  #
  # init :ssr
  #

  # Uncomment to use file-based dynamic template routing via Roda (make sure you
  # uncomment the gem dependency in your `Gemfile` as well):
  #
  # init :"bridgetown-routes"
  #

  # We also recommend that if you're using Roda routes you include this plugin
  # so you can get a generated routes list in `.routes.json`. You can then run
  # `bin/bridgetown roda:routes` to print the routes. (This will require you to
  # comment your route blocks. See example in `server/routes/hello.rb.sample`.)
  #
  # only :server do
  #   init :parse_routes
  # end
  #

  # For more documentation on how to configure your site using this initializers file,
  # visit: https://edge.bridgetownrb.com/documentation/configuration/initializers/
  init :"bridgetown-cloudinary" do
    cloud_name "andrewmcodes"
  end
end

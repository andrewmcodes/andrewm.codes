source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

####
# Welcome to your project's Gemfile, used by Rubygems & Bundler.
#
# To install a plugin, run:
#
#   bundle add new-plugin-name -g bridgetown_plugins
#
# This will ensure the plugin is added to the correct Bundler group.
#
# When you run Bridgetown commands, we recommend using a binstub like so:
#
#   bin/bridgetown start (or console, etc.)
#
# This will help ensure the proper Bridgetown version is running.
####

gem "rack", "~> 2.2"

# If you need to upgrade/switch Bridgetown versions, change the line below
# and then run `bundle update bridgetown`
gem "bridgetown", "~> 1.2.0.beta3"

# Uncomment to add file-based dynamic routing to your project:
# gem "bridgetown-routes", "~> 1.2.0.beta3"

# Uncomment to use the Inspectors API to manipulate the output
# of your HTML or XML resources:
gem "nokogiri", "~> 1.13"

# Puma is a Rack-compatible server used by Bridgetown
# (you can optionally limit this to the "development" group)
gem "puma", "~> 5.6"

# https://github.com/bkeepers/dotenv
gem "dotenv", "~> 2.8"
# https://github.com/bridgetownrb/bridgetown-feed
gem "bridgetown-feed", "~> 3.0"
# https://github.com/bridgetownrb/bridgetown-cloudinary
gem "bridgetown-cloudinary", "~> 2.1"
# https://github.com/bridgetownrb/bridgetown-view-component
gem "bridgetown-view-component", "~> 1.0"
# https://github.com/ayushn21/bridgetown-svg-inliner
gem "bridgetown-svg-inliner", "~> 1.0"
# https://github.com/ayushn21/bridgetown-sitemap
gem "bridgetown-sitemap", "~> 1.1.2"
gem "railties", "~> 7.0", ">= 7.0.4"

group :development do
  gem "erb-formatter", "~> 0.3"
  gem "standard", "~> 1.16"
  gem "solargraph", "~> 0.47"
end

group :test, optional: true do
  gem "minitest"
  gem "minitest-profile"
  gem "minitest-reporters"
  gem "shoulda"
  gem "rails-dom-testing"
end

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
#
# To install a plugin, run bundle add and specify the group
# "bridgetown_plugins". For example:
#
#   bundle add some-new-plugin -g bridgetown_plugins
#

gem "bridgetown", "~> 1.0.0"
gem "puma", "~> 5.6"

group :development do
  gem "debug", "~> 1.4"
  gem "standard", "~> 1.7"
  gem "solargraph", "~> 0.44"
end

group :bridgetown_plugins do
  gem "bridgetown-view-component", "~> 0.7.0"
  gem "bridgetown-svg-inliner", "~> 1.0"
  gem "bridgetown-cloudinary", "~> 1.2"
  gem "bridgetown-plausible", "~> 1.0.2"
  gem "view_component", "< 2.47"
  gem "bridgetown-feed", "~> 2.1.0"
end

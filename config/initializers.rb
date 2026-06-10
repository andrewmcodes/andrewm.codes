Bridgetown.configure do |config|
  url "https://andrewm.codes"
  permalink "/:path.*/"
  timezone "America/Phoenix"
  template_engine "erb"

  init :dotenv
  init :"bridgetown-feed"
  init :"bridgetown-sitemap"
  init :"bridgetown-svg-inliner"

  pagination do
    enabled true
  end
end

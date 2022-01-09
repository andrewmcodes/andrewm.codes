module MyFilters
  #
  # Build OG Image URL with mugshotbot
  #
  # @param [String] mode The color mode: 'dark' or 'light'
  # @param [String] color Hex value of the primary color.
  # @param [String] pattern The mugshotbot pattern
  # @param [String] url The URL to build the image for
  #
  # @return [String] The mugshotbot image URL based on the supplied parameters
  #
  def og_image(mode: "light", color: "007aff", pattern: "diagonal_lines", url: "andrewm.codes/")
    "https://mugshotbot.com/m?mode=#{mode}&color=#{color}&pattern=#{pattern}&hide_watermark=true&url=#{url}"
  end

  #
  # Build Twitter Intent URL for sharing the page
  #
  # @param [Bridgetown::Resource] resource The page resource
  #
  # @return [String] The escaped Twitter Intent URL
  #
  def twitter_share_url(resource)
    title = uri_escape resource.data.title
    url = resource.absolute_url

    "https://mobile.twitter.com/intent/tweet/?text=#{title}%20by%20@andrewmcodes%20#{url}"
  end

  #
  # Build Twitter Search Query URL for searching for the page on Twitter
  #
  # @param [Bridgetown::Resource] resource The page resource
  #
  # @return [String] The escaped Twitter Search Query URL
  #
  def twitter_discuss_url(resource)
    "https://mobile.twitter.com/search?q=#{uri_escape resource.absolute_url}"
  end

  #
  # Build GitHub URL for mapping the current page to a file in GitHub
  #
  # @param [Bridgetown::Resource] resource The page resource
  #
  # @return [String] A link to the current page in GitHub
  #
  def github_edit_url(resource)
    "https://github.com/#{site.metadata.repo}/blob/main/src/#{resource.relative_path}"
  end
end

Bridgetown::RubyTemplateView::Helpers.include MyFilters

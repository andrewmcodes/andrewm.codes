module Filters
  def post?(resource)
    resource.try(:collection) && resource.collection.label == "posts"
  end

  def project?(resource)
    resource.try(:collection) && resource.collection.label == "projects"
  end

  def home?(resource)
    resource&.relative_url == "/"
  end

  def build_title(resource)
    return resource.data.title if resource.data.title && resource.relative_url != "/"
    return site.metadata.long_title if resource.relative_url == "/"

    "#{site.metadata.title} #{site.metadata.tagline}"
  end

  def parse_date(date)
    Bridgetown::Utils.parse_date(date)
  end

  def in_last_year?(date)
    (Time.now - date) / 31536000 < 1
  end

  #
  # Build Twitter Intent URL for sharing the page
  # @param [Bridgetown::Resource] resource The page resource
  # @return [String] The escaped Twitter Intent URL
  #
  def twitter_share_url(resource)
    title = uri_escape resource.data.title
    url = uri_escape resource.absolute_url

    "https://mobile.twitter.com/intent/tweet/?text=#{title}%20by%20@andrewmcodes&url=#{url}"
  end

  #
  # Build Twitter Search Query URL for searching for the page on Twitter
  # @param [Bridgetown::Resource] resource The page resource
  # @return [String] The escaped Twitter Search Query URL
  #
  def twitter_discuss_url(resource)
    "https://mobile.twitter.com/search?q=#{uri_escape resource.absolute_url}"
  end

  #
  # Build GitHub URL for mapping the current page to a file in GitHub
  # @param [Bridgetown::Resource] resource The page resource
  # @return [String] A link to the current page in GitHub
  #
  def github_edit_url(resource)
    "https://github.com/#{site.metadata.repo}/blob/main/src/#{resource.relative_path}"
  end
end

Bridgetown::RubyTemplateView::Helpers.include Filters

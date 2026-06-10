# Site-wide responsive top navigation and command-palette trigger.
class Topbar < Bridgetown::Component
  COLLECTION_NAV = {
    "posts" => "/posts/",
    "projects" => "/projects/",
    "cfps" => "/speaking/"
  }.freeze

  # @param resource [Bridgetown::Resource::Base] current page resource
  def initialize(resource:)
    @resource = resource
    @site = Bridgetown::Current.site
  end

  def nav_items
    @site.data.navigation
  end

  def metadata
    @site.metadata
  end

  def active?(item_url)
    current = @resource.relative_url.to_s
    return current == "/" if item_url == "/"

    collection_label = @resource.respond_to?(:collection) ? @resource.collection&.label : nil
    if (mapped = COLLECTION_NAV[collection_label]) && mapped == item_url
      return true
    end

    current.start_with?(item_url.to_s)
  end
end

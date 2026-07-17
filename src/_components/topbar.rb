# Site-wide responsive top navigation and command-palette trigger.
#
# Desktop nav collapses into a hamburger-triggered mobile sheet below the
# custom `nav:` (820px) breakpoint; the wordmark/handle further compact below
# `compact:` (520px) (see the `--breakpoint-nav`/`--breakpoint-compact`
# tokens in frontend/styles/index.css). Every id/data-*/aria-* attribute
# rendered here is read by frontend/javascript/mobile_menu.js and cmdk.js —
# do not rename without updating both.
class Topbar < Base
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

  # Nav items, minus the RSS entry (rendered separately in the mobile sheet
  # with its own icon).
  def nav_items
    @site.data.navigation.reject { |item| item.label == "RSS" }
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

  # Extra class layered on top of the shared Link `:nav` variant.
  def nav_item_class(item)
    if active?(item.url)
      "text-sage-12 relative after:absolute after:left-2.5 after:right-2.5 after:bottom-0.5 after:h-[1.5px] after:bg-mint-11 after:rounded-sm"
    else
      "text-sage-11"
    end
  end

  # Extra class layered on top of the shared Link `:nav_mobile` variant.
  def mobile_item_class(item)
    active?(item.url) ? "bg-mint-3 text-mint-11 font-medium" : "text-sage-11 hover:bg-sage-3 hover:text-sage-12"
  end

  def mobile_chevron_class(item)
    active?(item.url) ? "text-mint-11" : "text-sage-7 -translate-x-1 opacity-0 transition group-hover:translate-x-0 group-hover:opacity-100"
  end
end

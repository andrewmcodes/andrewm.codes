# Compact tag navigation used on archive and listing pages.
class TagCloud < Base
  # @param tags [Array<String>] tags to render
  # @param label [String] short label before the tag links
  # @param href_prefix [String] URL prefix used before each tag slug
  def initialize(tags:, label: "tags", href_prefix: "/tag/")
    @tags = tags
    @label = label
    @href_prefix = href_prefix
    super()
  end
end

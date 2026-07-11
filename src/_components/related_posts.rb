# Related-posts block for the post footer.
#
# Surfaces a few crawlable internal links to posts sharing tags with the
# current one. Renders nothing when there are no related posts.
class RelatedPosts < Base
  # @param posts [Array<Bridgetown::Resource::Base>] precomputed related posts
  def initialize(posts:)
    @posts = Array(posts)
    super()
  end

  def render?
    @posts.any?
  end

  attr_reader :posts

  # @return [String] classes for the row link itself (mono, muted, mint on hover)
  def link_classes
    cx(
      "group flex items-baseline gap-3 py-1.5 transition-colors hover:text-mint-11",
      FONT_FAMILY[:mono],
      TEXT_SIZES[:sm],
      TEXT_SCHEME[:muted]
    )
  end

  # @return [String] classes for the serif post title within the row
  def title_classes
    cx(FONT_FAMILY[:serif], TEXT_SIZES[:sm], TEXT_SCHEME[:strong], "group-hover:text-mint-11 transition-colors")
  end
end

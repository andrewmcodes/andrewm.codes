# Related-posts block for the post footer.
#
# Surfaces a few crawlable internal links to posts sharing tags with the
# current one. Renders nothing when there are no related posts.
class RelatedPosts < Bridgetown::Component
  # @param posts [Array<Bridgetown::Resource::Base>] precomputed related posts
  def initialize(posts:)
    @posts = Array(posts)
  end

  def render?
    @posts.any?
  end

  attr_reader :posts
end

# Who wrote this, at the end of the post.
#
# PRODUCT.md's second principle is that deep links are front doors: most
# readers never see the homepage, so a post has to orient the stranger, prove
# the author, and offer the next thing. It did the first and the third. A
# reader arriving cold on a 2021 GitHub Actions tutorial could reach the
# bottom without ever learning that the author is a Rails engineer, or that
# "Andrew Mason" in the bar is the same person as the byline.
#
# Every fact here is from PRODUCT.md and already true elsewhere on the site.
class PostAuthor < Bridgetown::Component
  def initialize
    @site = Bridgetown::Current.site
  end

  def name = @site.metadata.author.name

  def handle = @site.metadata.handle
end

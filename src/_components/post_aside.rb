# The reading page's margin: everything true *about* the post, kept out of the
# post itself.
#
# A reader arriving from a search result needs to know when this was written,
# how long it will take, who wrote it, and what is in it — but none of that is
# the writing, so none of it belongs in the reading column. On desktop it sits
# in the margin and follows the scroll; below `nav` the layout's `order` puts it
# after the title, so a reader meets the post's name before its machinery.
#
# The back link is deliberately not here — it leads out of the page, so the
# layout renders it above the title.
class PostAside < Bridgetown::Component
  # @param resource [Bridgetown::Resource::Base] the post
  # @param show_toc [Boolean] whether the post is long enough to earn contents
  # @param class [String] grid placement, owned by the layout rather than here
  def initialize(resource:, show_toc: false, **opts)
    @resource = resource
    @show_toc = show_toc
    @placement = opts[:class].to_s
  end

  attr_reader :placement

  def date = @resource.date

  def reading_time = @resource.reading_time

  def author_name
    @resource.data.author || Bridgetown::Current.site.metadata.author.name
  end

  def tags = Array(@resource.data.tags)

  def show_toc? = @show_toc
end

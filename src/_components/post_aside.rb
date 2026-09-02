# The reading page's margin: everything true *about* the post, kept out of the
# post itself.
#
# A reader arriving from a search result needs to know when this was written,
# how long it will take, who wrote it, and what is in it — but none of that is
# the writing, so none of it belongs in the reading column. On desktop it sits
# in the margin and follows the scroll; below `nav` it collapses back above the
# article, where a margin does not exist.
class PostAside < Bridgetown::Component
  # @param resource [Bridgetown::Resource::Base] the post
  # @param back [Hash] `{"path" =>, "label" =>}` breadcrumb
  # @param show_toc [Boolean] whether the post is long enough to earn contents
  def initialize(resource:, back:, show_toc: false)
    @resource = resource
    @back = back
    @show_toc = show_toc
  end

  attr_reader :back

  def date = @resource.date

  def reading_time = @resource.reading_time

  def author_name
    @resource.data.author || Bridgetown::Current.site.metadata.author.name
  end

  def tags = Array(@resource.data.tags)

  def show_toc? = @show_toc
end

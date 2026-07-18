# Post detail header with title, publish date, reading time, and tag links.
class PostHeader < Bridgetown::Component
  attr_reader :resource

  # @param resource [Bridgetown::Resource::Base] post-like resource
  def initialize(resource:)
    @resource = resource
  end

  def title
    @resource.data.title
  end

  def date
    @resource.date
  end

  def reading_time
    @resource.reading_time
  end

  # CFPs are archival, event-tied proposals — their tags aren't browsable
  # topics, so suppress them in the header.
  def tags
    return [] if @resource.data.kind == "cfp"
    Array(@resource.data.tags)
  end

  def tag_slug(tag)
    tag.to_s.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-|-+\z/, "")
  end

  def author_name
    Bridgetown::Current.site.metadata.author.name
  end
end

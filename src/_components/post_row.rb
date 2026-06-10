# Post archive row with date, title, tags, reading time, and internal affordance.
class PostRow < Bridgetown::Component
  # @param post [Bridgetown::Resource::Base] post resource
  def initialize(post:)
    @post = post
  end

  def date_str
    @post.date.strftime("%b %-d, %Y")
  end

  def tags
    Array(@post.data.tags).first(3)
  end

  def reading
    "#{@post.reading_time} min"
  end

  def section_label
    @post.data.section || "Blog"
  end

  def tags_data
    Array(@post.data.tags).join(",")
  end
end

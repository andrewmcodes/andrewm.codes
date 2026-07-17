# Post archive row with date, title, tags, reading time, and internal affordance.
class PostRow < Base
  ROW_CLASSES = "group items-baseline py-3.5 border-b border-sage-4 max-md:gap-1.5"

  # @param post [Bridgetown::Resource::Base] post resource
  def initialize(post:)
    @post = post
    super()
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

  def tags_data
    Array(@post.data.tags).join(",")
  end

  # @return [String] the row's grid template + hover/border chrome, sourced
  #   from Columns' shared 96px `:list_row` template.
  def row_classes
    cx(ROW_CLASSES, Columns::TEMPLATES[:list_row], Columns::GAPS[:lg])
  end
end

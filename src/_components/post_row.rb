# One post as a list row.
#
# Two shapes, decided by the surface rather than by the post: the homepage
# shows a bare title, because five titles are a sample and a column of dates
# beside them turns a selection into a feed; the archive shows the title with
# its date at the right edge, because that is where a reader is actually
# choosing by recency.
class PostRow < Bridgetown::Component
  # @param post [Bridgetown::Resource::Base] post resource
  # @param show_reading [Boolean] print the reading time in the facts row
  # @param show_date [Boolean] print the date at the row's right edge
  # @param show_tags [Boolean] print the post's tags under the title
  # @param clamp_title [Boolean] hold the title to one line
  def initialize(post:, show_reading: true, show_date: true, show_tags: true,
    clamp_title: false, lead_date: nil)
    @post = post
    @show_reading = show_reading
    # `lead_date:` is the old parameter name and meant the same thing.
    @show_date = lead_date.nil? ? show_date : lead_date
    @show_tags = show_tags
    @clamp_title = clamp_title
  end

  def clamp_title? = @clamp_title

  def show_reading? = @show_reading

  def show_date? = @show_date

  def facts = show_reading? ? [reading] : []

  def date_str
    @post.date.strftime("%b %-d, %Y")
  end

  def tags
    @show_tags ? Array(@post.data.tags).first(3) : []
  end

  def reading
    "#{@post.reading_time} min"
  end

  def tags_data
    Array(@post.data.tags).join(",")
  end
end

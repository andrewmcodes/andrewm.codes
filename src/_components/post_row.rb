# Post archive row with date, title, tags, reading time, and internal affordance.
class PostRow < Bridgetown::Component
  # @param post [Bridgetown::Resource::Base] post resource
  # @param show_reading [Boolean] whether to print the reading time
  #   Off on the homepage: a column of "1 min" and "2 min" advertises a body of
  #   work as a stack of snippets. It earns its place in the post's own rail,
  #   where a reader is deciding whether to commit.
  # @param lead_date [Boolean] date in the lead column, or folded into the meta
  #   row. Off on the homepage, where `PageSection` already owns the left
  #   margin and a second lead column would open a rail inside a rail.
  def initialize(post:, show_reading: true, lead_date: true)
    @post = post
    @show_reading = show_reading
    @lead_date = lead_date
  end

  def show_reading? = @show_reading

  def lead_date? = @lead_date

  def facts = [(date_str unless lead_date?), (reading if show_reading?)].compact

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

class PostComponent < BaseComponent
  attr_reader :post

  def initialize(post:)
    @post = post
  end

  def description
    if post.collection.label == "posts"
      "#{formatted_date} - #{reading_time(post.content)} min read"
    else
      post.data.description.to_s
    end
  end

  def title
    post.data.title.to_s
  end

  def formatted_date
    date_to_string post.data.date, "ordinal", "US"
  end
end

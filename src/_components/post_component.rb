class PostComponent < BaseComponent
  attr_reader :post

  def initialize(post:)
    @post = post
  end

  def description
    post.data.description.to_s
  end

  def title
    post.data.title.to_s
  end
end

class Section < Base
  COMPONENT_OPTIONS = [:title]

  private

  def title
    opts[:title]
  end

  def id
    opts[:id] || title.downcase.tr(" ", "-")
  end
end

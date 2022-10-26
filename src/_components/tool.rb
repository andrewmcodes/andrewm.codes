class Tool < Base
  COMPONENT_OPTIONS = [:title, :description]

  private

  def title
    opts[:title]
  end

  def description
    opts[:description]
  end
end

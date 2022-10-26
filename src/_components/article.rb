class Article < Base
  COMPONENT_OPTIONS = [:resource]

  private

  def resource
    opts[:resource]
  end
end

class Image < BoxComponent
  private

  def add_options
    opts[:loading] ||= "lazy"
  end

  def default_tag
    :img
  end
end

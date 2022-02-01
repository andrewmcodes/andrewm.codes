class Image < BoxComponent
  private

  def add_options
    opts[:loading] = "lazy" if opts[:loading].nil?
  end

  def default_tag
    :img
  end
end

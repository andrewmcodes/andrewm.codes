class Image < BoxComponent
  def post_initialize(**opts)
    opts[:loading] ||= "lazy"
  end

  private

  def classes
    class_list = opts[:classes]&.split(" ") || []
    class_list.join(" ")
  end

  def as
    opts[:as] || :img
  end
end

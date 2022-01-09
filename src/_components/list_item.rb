class ListItem < BoxComponent
  private

  def classes
    class_list = opts[:classes]&.split(" ") || []
    class_list << opts.fetch(:py, "py-2")

    cleanup_keys :py
    class_list.join(" ")
  end

  def as
    opts[:as] || :li
  end
end

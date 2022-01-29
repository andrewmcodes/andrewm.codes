class Text < BoxComponent
  private

  def classes
    class_list = opts[:classes]&.split(" ") || []
    class_list << opts.fetch(:align, "text-left")
    class_list << "truncate" if opts[:truncate]

    cleanup_keys :align, :truncate
    class_list.join(" ")
  end

  def as
    opts.fetch(:as, :p)
  end
end

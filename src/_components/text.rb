class Text < BoxComponent
  private

  def classes
    class_list = opts[:classes]&.split(" ") || []
    class_list << (opts[:align]&.to_s || "left").prepend("text-") && opts.delete(:align)
    class_list << "truncate" && opts.delete(:truncate) if opts[:truncate]
    class_list << "text-skin#{opts[:skin]&.to_s&.prepend("-")}" && opts.delete(:skin)

    cleanup_keys :align, :truncate, :skin
    class_list.join(" ")
  end

  def as
    opts.fetch(:as, :p)
  end
end

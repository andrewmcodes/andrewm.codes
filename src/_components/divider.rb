class Divider < BoxComponent
  private

  def classes
    class_list = opts[:classes]&.split(" ") || []
    class_list << opts.fetch(:border, "border-t-1 border-skin-divider")
    class_list << opts.fetch("spacing", "my-6")

    cleanup_keys :spacing, :border
    class_list.join(" ")
  end

  def as
    :hr
  end
end

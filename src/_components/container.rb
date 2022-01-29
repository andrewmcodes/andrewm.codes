class Container < BoxComponent
  private

  def classes
    class_list = opts[:classes]&.split(" ") || []
    class_list << "w-full mx-auto max-w-prose"
    class_list << opts.fetch(:spacing, "px-4")

    class_list.join(" ")
  end

  def as
    opts[:as] || :div
  end
end

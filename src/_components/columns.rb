class Columns < BoxComponent
  private

  BASE_CLASSES = %(flex flex-col).freeze
  DEFAULT_SPACING = "space-y-4".freeze

  def classes
    class_list = opts[:classes]&.split(" ") || []
    class_list << BASE_CLASSES
    class_list << opts.fetch(:spacing, DEFAULT_SPACING)

    class_list.flatten.join(" ")
  end
end

class Alert < BoxComponent
  private

  BASE_CLASSES = %(px-4 py-3 text-sm).freeze

  def classes
    class_list = opts[:classes]&.split(" ") || []
    class_list << level_classes(opts.fetch(:level, :info).to_sym)
    class_list << BASE_CLASSES

    cleanup_keys :level
    class_list.flatten.join(" ")
  end

  def level_classes(level)
    case level
    when :success
      "text-green-700 bg-green-500 rounded-md dark:text-green-400 bg-opacity-10"
    when :warning
      "text-yellow-700 bg-yellow-500 rounded-md dark:text-yellow-400 bg-opacity-10"
    when :error
      "text-red-700 bg-red-500 rounded-md dark:text-red-400 bg-opacity-10"
    else
      "text-sky-700 bg-sky-500 rounded-md dark:text-sky-400 bg-opacity-10"
    end
  end
end

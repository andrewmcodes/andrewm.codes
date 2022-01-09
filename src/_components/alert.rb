class Alert < BoxComponent
  private

  def classes
    class_list = opts[:classes]&.split(" ") || []
    class_list << level_classes(opts.fetch(:level, :info).to_sym)

    cleanup_keys :level
    class_list.flatten.join(" ")
  end

  def level_classes(level)
    case level
    when :success
      "px-4 py-3 text-sm text-green-700 bg-green-500 rounded-md dark:text-green-400 bg-opacity-10"
    when :warning
      "px-4 py-3 text-sm text-yellow-700 bg-yellow-500 rounded-md dark:text-yellow-400 bg-opacity-10"
    when :error
      "px-4 py-3 text-sm text-red-700 bg-red-500 rounded-md dark:text-red-400 bg-opacity-10"
    else
      "px-4 py-3 text-sm text-blue-700 bg-blue-500 rounded-md dark:text-blue-400 bg-opacity-10"
    end
  end
end

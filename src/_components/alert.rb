class Alert < BoxComponent
  private

  BASE_CLASSES = %(py-3 text-sm).freeze

  def classes
    [variant_classes(variant), BASE_CLASSES, DEFAULT_PX]
  end

  def variant_classes(name)
    case name
    when :success
      "text-green-700 bg-green-500 rounded-md dark:text-green-400 bg-opacity-10"
    when :warning
      "text-yellow-700 bg-yellow-500 rounded-md dark:text-yellow-400 bg-opacity-10"
    when :error
      "text-red-700 bg-red-500 rounded-md dark:text-red-400 bg-opacity-10"
    else
      "text-pink-700 bg-pink-500 rounded-md dark:text-pink-400 bg-opacity-10"
    end
  end
end

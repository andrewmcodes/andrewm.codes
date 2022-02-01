class Heading < BoxComponent
  private

  def classes
    class_list = []
    class_list << opts.fetch(:align, "text-left")
    class_list << "truncate" if opts[:truncate]
    class_list << level_classes(level)
    class_list
  end

  def default_tag
    "h#{level}".to_sym
  end

  def remove_options
    [:align, :truncate, :level]
  end

  def level
    @level ||= opts.fetch(:level, 1)
  end

  def level_classes(i)
    case i
    when 1
      "text-4xl font-bold tracking-tight leading-normal"
    when 2
      "text-2xl font-semibold"
    when 3
      "font-semibold tracking-wide break-words text-md"
    when 4
      "break-words text-md"
    else
      "text-base font-semibold"
    end
  end
end

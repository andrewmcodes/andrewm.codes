class Heading < BoxComponent
  private

  def classes
    class_list = opts[:classes]&.split(" ") || []
    class_list << (opts[:align] || "left").prepend("text-") && opts.delete(:align)
    class_list << "truncate" if opts[:truncate]
    operator = opts[:level] && opts[:as] && "h#{opts[:level]}" != opts[:as] ? "h#{opts[:level]}" : as
    class_list << heading_classes(operator) unless opts[:override_classes]

    cleanup_keys :align, :truncate, :slin, :level, :override_classes
    class_list.join(" ")
  end

  def as
    opts[:as] || "h#{opts[:level] || 1}"
  end

  def heading_classes(operator)
    case operator
    when "h1"
      "text-4xl font-bold tracking-tight leading-normal"
    when "h2"
      "text-2xl font-semibold"
    when "h3"
      "font-semibold tracking-wide break-words text-md"
    when "h4"
      "break-words text-md"
    else
      "text-base font-semibold"
    end
  end
end

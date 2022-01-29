class List < BoxComponent
  def before_render
    opts[:role] ||= "list"
  end

  private

  def classes
    class_list = opts[:classes]&.split(" ") || []
    class_list << opts.fetch(:divide, "divide-y divide-zinc-300 dark:divide-zinc-700")
    class_list << "not-prose list-none pl-0"
    class_list.join(" ")
  end

  def as
    opts.fetch(:as, :ul)
  end
end

class Link < BoxComponent
  def call
    external = opts[:external] || opts[:href].to_s.starts_with?("https")
    opts[:target] = "_blank" if external
    opts[:rel] = "noopener noreferrer" if external
    href = opts[:href]
    opts.delete(:href)
    link_to content, href, class: classes, **opts
  end

  private

  def classes
    class_list = opts[:classes]&.split(" ") || []
    class_list << opts.fetch(:hover, "hover:text-sky-500 dark:hover:text-pink-500")
    class_list << opts.fetch(:weight, "font-semibold")
    class_list << "text-sky-500 dark:hover:text-pink-500" if opts[:active]

    cleanup_keys :hover, :active

    class_list.join(" ")
  end

  def as
    h_level = opts.fetch(:as, :p)
    opts.delete(:as)
    h_level
  end
end

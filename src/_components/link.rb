class Link < BoxComponent
  BUTTON_LINK_CLASSES = "inline-flex items-center justify-center p-2 text-sm font-medium rounded-md bg-zinc-100 dark:bg-zinc-800 text-zinc-700 dark:text-zinc-300 hover:bg-zinc-300 hover:text-zinc-800 dark:hover:bg-zinc-700 dark:hover:text-zinc-300 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-zinc-50 dark:focus:ring-zinc-900"

  def call
    external = opts[:external] || opts[:href].to_s.starts_with?("https")
    opts[:target] = "_blank" if external
    opts[:rel] = "noopener noreferrer" if external
    href = opts[:href]
    cleanup_keys :href, :as
    link_to content, href, class: classes, **opts
  end

  private

  def classes
    class_list = opts[:classes]&.split(" ") || []
    class_list << opts.fetch(:hover, "hover:text-sky-500 dark:hover:text-pink-500")
    class_list << opts.fetch(:weight, "font-semibold")
    class_list << "!text-sky-500 dark:!text-pink-500" if opts[:active]

    cleanup_keys :hover, :active

    button_link? ? BUTTON_LINK_CLASSES : class_list.join(" ")
  end

  def button_link?
    opts.fetch(:button, false)
  end

  def as
    opts.fetch(:as, :p)
  end
end

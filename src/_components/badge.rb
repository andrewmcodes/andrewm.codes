class Badge < BoxComponent
  def call
    if opts[:href]
      link_to get_tag, opts[:href]
    else
      get_tag
    end
  end

  private

  def get_tag
    tag.send as, content, class: classes, **opts
  end

  def classes
    class_list = opts[:classes]&.split(" ") || []
    class_list << "inline-flex items-center px-2 py-1 rounded text-sm font-medium bg-zinc-800 text-zinc-100 leading-none"

    class_list.join(" ")
  end

  def as
    opts[:as] || :span
  end
end

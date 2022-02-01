class Text < BoxComponent
  private

  def classes
    [
      opts.fetch(:align, "text-left"),
      ("truncate" if opts[:truncate]),
      ("line-clamp-2" if opts[:truncate]),
      ("text-sm" if opts[:small])
    ]
  end

  def remove_options
    [:align, :truncate]
  end

  def default_tag
    :p
  end
end

class Text < BoxComponent
  private

  def classes
    [
      opts.fetch(:align, "text-left"),
      ("truncate" if opts[:truncate])
    ]
  end

  def remove_options
    [:align, :truncate]
  end

  def default_tag
    :p
  end
end

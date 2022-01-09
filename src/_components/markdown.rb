class Markdown < BoxComponent
  private

  def classes
    class_list = opts[:classes]&.split(" ") || []
    class_list << %w[
      after:prose-code:content-['']
      before:prose-code:content-['']
      dark:prose-invert
      prose
      prose-code:bg-skin-code
      prose-code:font-medium
      prose-code:p-1
      prose-code:rounded
      prose-code:text-skin-code
      prose-pre:bg-skin-code
      prose-pre:px-2
      prose-neutral
      prose-headings:text-skin-primary
    ]

    class_list.flatten.join(" ")
  end

  def as
    h_level = opts.fetch(:as, :div)
    opts.delete(:as)
    h_level
  end
end

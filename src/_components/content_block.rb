class ContentBlock < BoxComponent
  private

  def classes
    class_list = opts[:classes]&.split(" ") || []
    class_list << %w[
      after:prose-code:content-['']
      before:prose-code:content-['']
      dark:prose-invert
      prose
      prose-code:bg-zinc-800
      prose-code:font-medium
      prose-code:p-1
      prose-code:rounded
      prose-code:text-zinc-100
      prose-pre:bg-zinc-800
      prose-pre:px-2
      prose-zinc
      prose-a:text-sky-500
      dark:prose-a:text-pink-500
      prose-a:no-underline
      hover:prose-a:underline
      hover:prose-a:underline-offset-2
      prose-blockquote:border-sky-500
      dark:prose-blockquote:border-pink-500
    ]

    class_list.flatten.join(" ")
  end

  def as
    h_level = opts.fetch(:as, :div)
    opts.delete(:as)
    h_level
  end
end

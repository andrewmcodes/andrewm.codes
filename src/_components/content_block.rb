class ContentBlock < BoxComponent
  private

  def classes
    %w[
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
      prose-a:text-pink-500
      dark:prose-a:text-sky-400
      prose-a:no-underline
      hover:prose-a:underline
      hover:prose-a:underline-offset-2
      prose-blockquote:border-pink-500
      dark:prose-blockquote:border-sky-400
      prose-blockquote:bg-pink-100/20
      dark:prose-blockquote:bg-sky-900/10
      prose-blockquote:not-italic
    ]
  end
end

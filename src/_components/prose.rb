# Typography wrapper for markdown-rendered content.
class Prose < Box
  COMPONENT_OPTIONS = %i[size max_w variant].freeze

  PROSE_SIZES = {
    default: "prose-base",
    lg: "prose-xl"
  }.freeze

  PROSE_VARIANTS = {
    default: "",
    page: "max-w-none text-sage-11 text-[17px] leading-[1.75] [&_:not(pre)>code]:bg-sage-3 [&_:not(pre)>code]:text-sage-12 [&_:not(pre)>code]:px-1.5 [&_:not(pre)>code]:py-0.5 [&_:not(pre)>code]:rounded [&_:not(pre)>code]:border [&_:not(pre)>code]:border-sage-4 [&_:not(pre)>code]:font-normal [&_:not(pre)>code]:before:content-none [&_:not(pre)>code]:after:content-none",
    post: "max-w-none text-sage-11 text-[17px] leading-[1.75] prose-h2:text-2xl prose-h2:leading-tight prose-h2:mt-12 prose-h2:mb-4 prose-h3:text-lg prose-h3:leading-snug prose-h3:mt-10 prose-h3:mb-3 prose-h4:text-[15px] prose-h4:font-mono prose-h4:uppercase prose-h4:tracking-[0.04em] prose-h4:text-sage-11 prose-h4:mt-8 prose-h4:mb-2 prose-blockquote:border-l-[3px] prose-blockquote:border-mint-11 prose-blockquote:not-italic prose-blockquote:text-sage-12 [&_:not(pre)>code]:bg-sage-3 [&_:not(pre)>code]:text-sage-12 [&_:not(pre)>code]:px-1.5 [&_:not(pre)>code]:py-0.5 [&_:not(pre)>code]:rounded [&_:not(pre)>code]:border [&_:not(pre)>code]:border-sage-4 [&_:not(pre)>code]:font-normal [&_:not(pre)>code]:before:content-none [&_:not(pre)>code]:after:content-none"
  }.freeze

  private

  def classes
    cx(
      "prose prose-sage dark:prose-invert",
      "prose-headings:font-semibold prose-headings:tracking-tight prose-headings:text-sage-12",
      "prose-a:text-mint-11 prose-a:no-underline hover:prose-a:underline",
      "prose-code:text-sage-12 prose-code:bg-sage-3 prose-code:px-1.5 prose-code:py-0.5 prose-code:rounded prose-code:border prose-code:border-sage-5",
      PROSE_SIZES.fetch(opts[:size], PROSE_SIZES[:default]),
      PROSE_VARIANTS.fetch(opts[:variant], PROSE_VARIANTS[:default]),
      ("max-w-prose" unless opts[:max_w])
    )
  end
end

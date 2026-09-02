# Typography wrapper for markdown-rendered content.
class Prose < Box
  COMPONENT_OPTIONS = %i[size max_w variant].freeze

  PROSE_SIZES = {
    default: "prose-base",
    lg: "prose-xl"
  }.freeze

  # Inline `<code>` inside prose. Shared by every variant so a code span reads
  # identically wherever it appears.
  INLINE_CODE = <<~CLASSES.freeze
    [&_:not(pre)>code]:bg-slate-3 [&_:not(pre)>code]:text-slate-12
    [&_:not(pre)>code]:px-1.5 [&_:not(pre)>code]:py-0.5 [&_:not(pre)>code]:rounded
    [&_:not(pre)>code]:border [&_:not(pre)>code]:border-slate-4
    [&_:not(pre)>code]:font-normal [&_:not(pre)>code]:font-mono
    [&_:not(pre)>code]:before:content-none [&_:not(pre)>code]:after:content-none
  CLASSES

  # The reading column is Source Serif 4 while headings stay Archivo. The split
  # is the hierarchy: a heading is chrome announcing a section, the paragraph
  # under it is the writing.
  READING_COLUMN = "font-serif text-read prose-headings:font-sans".freeze

  PROSE_VARIANTS = {
    default: "",
    page: "max-w-none text-slate-11 #{READING_COLUMN} #{INLINE_CODE}",
    post: <<~CLASSES.freeze
      max-w-none text-slate-11 #{READING_COLUMN}
      prose-h2:text-title prose-h2:mt-12 prose-h2:mb-4
      prose-h3:text-row prose-h3:mt-10 prose-h3:mb-3
      prose-blockquote:border-l-[3px] prose-blockquote:border-ruby-11
      prose-blockquote:not-italic prose-blockquote:text-slate-12
      #{INLINE_CODE}
    CLASSES
  }.freeze

  private

  def classes
    cx(
      "prose prose-slate dark:prose-invert",
      "prose-headings:font-semibold prose-headings:tracking-tight prose-headings:text-slate-12",
      "prose-a:text-ruby-11 prose-a:no-underline hover:prose-a:underline",
      "prose-code:font-mono prose-code:text-slate-12 prose-code:bg-slate-3 prose-code:px-1.5 prose-code:py-0.5 prose-code:rounded prose-code:border prose-code:border-slate-5",
      PROSE_SIZES.fetch(opts[:size], PROSE_SIZES[:default]),
      PROSE_VARIANTS.fetch(opts[:variant], PROSE_VARIANTS[:default]),
      ("max-w-prose" unless opts[:max_w])
    )
  end
end

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
    [&_:not(pre)>code]:bg-mauve-3 [&_:not(pre)>code]:text-mauve-12
    [&_:not(pre)>code]:px-1.5 [&_:not(pre)>code]:py-0.5 [&_:not(pre)>code]:rounded
    [&_:not(pre)>code]:border [&_:not(pre)>code]:border-mauve-6
    [&_:not(pre)>code]:font-normal [&_:not(pre)>code]:font-mono
    [&_:not(pre)>code]:before:content-none [&_:not(pre)>code]:after:content-none
  CLASSES

  READING_COLUMN = "text-read".freeze

  # The measure is applied to the text children rather than to the container,
  # so a code block, a figure or a table can use the whole pane while the prose
  # stays at a reading width. `--measure` lives in index.css beside the pane
  # width, because the two are one decision.
  MEASURE = "prose-measured max-w-none".freeze

  PROSE_VARIANTS = {
    default: "",
    # No `max-w-none` here. Both variants used to emit it alongside the
    # `max-w-prose` below, and 65ch only won because `.max-w-prose` happens to
    # compile later — a measure holding by utility ordering rather than by
    # intent, which would have flipped to unbounded silently.
    page: "#{READING_COLUMN} #{INLINE_CODE}",
    post: <<~CLASSES.freeze
      #{READING_COLUMN}
      prose-h2:text-h2 prose-h2:mt-12 prose-h2:mb-4
      prose-h3:text-h3 prose-h3:mt-10 prose-h3:mb-3
      prose-blockquote:border-l prose-blockquote:border-mauve-6
      prose-blockquote:not-italic prose-blockquote:text-mauve-12
      #{INLINE_CODE}
    CLASSES
  }.freeze

  private

  def classes
    cx(
      "prose [&>:first-child]:mt-0 [&>:last-child]:mb-0",
      "prose-headings:font-semibold prose-headings:tracking-tight prose-headings:text-mauve-12",
      # Underlined, not coloured. Ruby-11 against the body slate measures
      # 1.09:1 in light and 1.01:1 in dark, so colour alone left links
      # effectively indistinguishable from prose — WCAG 1.4.1 wants 3:1 for a
      # colour-only distinction. The underline is the affordance; the colour is
      # only reinforcement, and the offset is already themed globally.
      "prose-a:text-mauve-12 prose-a:underline prose-a:decoration-ruby-11/70 hover:prose-a:decoration-ruby-11",
      "prose-code:font-mono prose-code:text-mauve-12 prose-code:bg-mauve-3 prose-code:px-1.5 prose-code:py-0.5 prose-code:rounded prose-code:border prose-code:border-mauve-6",
      PROSE_SIZES.fetch(opts[:size], PROSE_SIZES[:default]),
      PROSE_VARIANTS.fetch(opts[:variant], PROSE_VARIANTS[:default]),
      # `max_w: false` means "let the reading measure govern", which is the
      # 65ch prose measure — the layout's grid column is wider than that.
      (opts[:max_w] ? "max-w-none" : MEASURE)
    )
  end
end

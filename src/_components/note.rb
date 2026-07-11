# Markdown-aware callout block for prose content.
class Note < Box
  COMPONENT_OPTIONS = %i[scheme].freeze

  NOTE_SCHEME = {
    default: "bg-sage-2 text-sage-11 border-sage-6",
    accent: "bg-mint-3 text-mint-12 border-mint-6"
  }.freeze

  private

  def children
    markdownify(content)
  end

  def classes
    cx(
      "my-6 rounded-xl border p-4 leading-6 [&>:first-child]:mt-0 [&>:last-child]:mb-0",
      NOTE_SCHEME.fetch(opts[:scheme], NOTE_SCHEME[:default])
    )
  end
end

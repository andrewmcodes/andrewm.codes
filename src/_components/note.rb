# Markdown-aware callout block for prose content.
class Note < Base
  COMPONENT_OPTIONS = %i[scheme].freeze

  NOTE_SCHEME = {
    default: "bg-mauve-2 text-mauve-11 border-mauve-6",
    accent: "bg-ruby-3 text-ruby-12 border-ruby-6"
  }.freeze

  def call
    inner = markdownify(content).to_s
    cls = classes
    html -> { %(<div class="#{cls}">#{inner}</div>) }
  end

  private

  def classes
    cx(
      "my-6 rounded-lg border p-4 leading-6 [&>:first-child]:mt-0 [&>:last-child]:mb-0",
      NOTE_SCHEME.fetch(opts[:scheme], NOTE_SCHEME[:default])
    )
  end
end

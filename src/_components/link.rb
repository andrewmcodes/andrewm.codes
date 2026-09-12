# Link atom with internal/external handling and semantic variants.
#
# Every variant is one of two things: underlined, or inside something that
# responds as a whole. There is no third kind, and colour is never the only
# difference between a link and the text around it — ruby against body mauve
# measures barely over 1:1 in both themes, so a coloured word in a paragraph
# was never a distinction at all.
#
# @option opts [String] :href link destination
# @option opts [Symbol] :variant (`:default`) one of `LINK_VARIANTS`
# @option opts [Boolean] :external force external link behavior
class Link < Box
  COMPONENT_OPTIONS = %i[variant tone weight external href].freeze
  DEFAULT_TAG = :a

  UNDERLINE = "underline decoration-mauve-7 underline-offset-[0.22em] transition-colors".freeze

  LINK_VARIANTS = {
    default: "",
    nav: "text-nav",
    inline: "text-mauve-12 #{UNDERLINE} hover:decoration-ruby-11",
    # Carries the only contact link on the site and both ways out of the 404,
    # so it is the one variant that spends the accent on the word itself.
    inline_accent: "text-ruby-11 underline decoration-ruby-11/50 underline-offset-[0.22em] hover:decoration-ruby-11 transition-colors",
    tag: "inline-block px-1 -mx-1 py-1 -my-1 font-mono text-meta text-mauve-11 underline decoration-mauve-7 underline-offset-4 hover:text-mauve-12 hover:decoration-ruby-11 transition-colors",
    post_tag: "inline-block px-1 -mx-1 py-1 -my-1 font-mono text-meta text-mauve-11 underline decoration-mauve-7 underline-offset-4 hover:text-mauve-12 hover:decoration-ruby-11 transition-colors",
    action: "group inline-flex items-center gap-1.5 text-note text-mauve-11 #{UNDERLINE} hover:text-mauve-12",
    section_action: "group inline-flex items-center gap-1 text-label text-mauve-11 hover:text-mauve-12 transition-colors",
    post_nav: "inline-block px-1 -mx-1 py-1 -my-1 text-mauve-11 underline decoration-mauve-7 underline-offset-4 hover:text-mauve-12 hover:decoration-ruby-11 transition-colors",
    skip: "sr-only focus:not-sr-only focus:fixed focus:top-3 focus:left-3 focus:z-50 focus:px-3 focus:py-2 focus:bg-pane focus:text-mauve-12 focus:rounded-md focus:border focus:border-mauve-6"
  }.freeze

  private

  # ERB block content arrives padded with the template's own newlines, which
  # render as a real space inside the anchor — putting a gap before the comma
  # in "at <a>Podia</a>, co-host of". Strip it once here rather than fighting
  # whitespace at every call site.
  def children
    content.to_s.strip
  end

  def classes
    cx(
      LINK_VARIANTS.fetch(opts[:variant], LINK_VARIANTS[:default]),
      (token(TONE, opts[:tone], :inherit) if opts[:tone]),
      (TEXT_WEIGHT[opts[:weight]&.to_sym] if opts[:weight])
    )
  end

  def tag_opts
    t = {href: href}
    if external?
      t[:target] = "_blank"
      t[:rel] = "noreferrer"
    end
    t
  end

  def href
    @href ||= opts[:href]
  end

  def external?
    return true if opts[:external]
    href.to_s.start_with?("http") && !href.to_s.include?(@site.config.url.to_s)
  end
end

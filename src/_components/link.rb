# Link atom with internal/external handling and semantic variants.
#
# Use this instead of raw anchors for inline, tag, nav, and action links.
#
# @option opts [String] :href link destination
# @option opts [Symbol] :variant (`:default`) one of `LINK_VARIANTS`
# @option opts [Boolean] :external force external link behavior
class Link < Box
  COMPONENT_OPTIONS = %i[variant scheme weight external href].freeze
  DEFAULT_TAG = :a

  LINK_VARIANTS = {
    default: "",
    nav: "text-sm font-medium",
    inline: "text-slate-12 border-b border-slate-5 hover:text-ruby-11 hover:border-ruby-11 transition-colors",
    inline_accent: "text-ruby-11 hover:underline",
    tag: "font-mono text-xs py-1 text-slate-10 hover:text-ruby-11 transition-colors",
    post_tag: "font-mono text-meta text-slate-10 hover:text-ruby-11 transition-colors",
    action: "group inline-flex items-center gap-1.5 mt-7 font-mono text-note text-slate-11 border-b border-slate-5 pb-0.5 hover:text-ruby-11 hover:border-ruby-11 transition-colors",
    section_action: "inline-flex items-center gap-1.5 font-mono text-meta text-slate-10 hover:text-ruby-11 transition-colors group",
    post_nav: "text-slate-11 hover:text-ruby-11 transition-colors",
    skip: "sr-only focus:not-sr-only focus:fixed focus:top-2 focus:left-2 focus:z-50 focus:px-3 focus:py-2 focus:bg-slate-2 focus:text-slate-12 focus:rounded focus:border focus:border-slate-5"
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
      TEXT_SCHEME.fetch(opts[:scheme], TEXT_SCHEME[:default]),
      TEXT_WEIGHT[opts[:weight]&.to_sym]
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

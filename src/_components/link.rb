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
    # Primary desktop nav item (Topbar). Hidden below the custom `nav:`
    # (820px) breakpoint in favor of the mobile menu. Active/inactive state
    # is layered on top via `class:` from Topbar#nav_item_class.
    nav: "font-mono text-xs px-2.5 py-1.5 rounded-md transition-colors hover:bg-sage-3 hover:text-sage-12 max-nav:hidden",
    # Full-width nav row inside the mobile menu sheet (Topbar). Active state
    # layered on top via `class:` from Topbar#mobile_item_class.
    nav_mobile: "group flex items-center justify-between gap-3 px-4 py-3 rounded-xl font-mono text-xs transition-colors",
    # Topbar wordmark/home link (avatar + name + handle).
    brand: "inline-flex items-center gap-3 font-semibold tracking-tight rounded-md",
    # Inline prose link — sage text, hairline underline, mint on hover.
    inline: "text-sage-12 border-b border-sage-5 hover:text-mint-11 hover:border-mint-11 transition-colors",
    # Emphasized inline link — mint text at rest, underline on hover.
    inline_accent: "text-mint-11 hover:underline",
    # Small mono chrome link — post tag lists, filter chips.
    tag: "font-mono text-xs py-1 text-sage-11 hover:text-mint-11 transition-colors",
    # Pill-shaped tag badge (post footer / archive tag clouds).
    post_tag: "px-2 py-0.5 rounded-full border border-sage-5 text-sage-11 hover:text-mint-11 hover:border-mint-11 text-[11px] transition-colors",
    # Standalone "read more"-style CTA under prose content.
    action: "group inline-flex items-center gap-1.5 mt-7 font-mono text-[13px] text-sage-11 border-b border-sage-5 pb-0.5 hover:text-mint-11 hover:border-mint-11 transition-colors",
    # Section header "view all" trailing link.
    section_action: "inline-flex items-center gap-1.5 font-mono text-[12.5px] text-sage-11 hover:text-mint-11 transition-colors group",
    # Compact back-navigation link atop post/archive detail pages.
    back: "group inline-flex items-center gap-1.5 mb-7 py-1 font-mono text-xs text-sage-11 hover:text-mint-11 transition-colors",
    # Prev/next post navigation links; also reused for plain footer chrome links.
    post_nav: "text-sage-11 hover:text-mint-11 transition-colors",
    # Mono meta link with a hairline underline (site footer account/feed row).
    underline_meta: "font-mono text-xs text-sage-11 border-b border-sage-5 pb-px hover:text-mint-11 hover:border-mint-11 transition-colors",
    # Visually-hidden skip-to-content link, revealed on focus.
    skip: "sr-only focus:not-sr-only focus:fixed focus:top-2 focus:left-2 focus:z-50 focus:px-3 focus:py-2 focus:bg-sage-2 focus:text-sage-12 focus:rounded focus:border focus:border-sage-5"
  }.freeze

  # Keyboard focus ring shared with Button; :skip owns its own focus styling.
  FOCUS_RING = "focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-mint-9 rounded-[2px]"

  private

  def classes
    cx(
      LINK_VARIANTS.fetch(opts[:variant], LINK_VARIANTS[:default]),
      TEXT_SCHEME.fetch(opts[:scheme], TEXT_SCHEME[:default]),
      TEXT_WEIGHT[opts[:weight]&.to_sym],
      (FOCUS_RING unless opts[:variant] == :skip)
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

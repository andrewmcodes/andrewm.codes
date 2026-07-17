# Text atom for tokenized paragraph and inline copy styles.
#
# @option opts [Symbol] :variant (`:default`) one of `VARIANTS`
# @option opts [Symbol] :size token from `Base::TEXT_SIZES`
# @option opts [Symbol] :scheme token from `Base::TEXT_SCHEME`
# @option opts [Symbol] :leading token from `Base::LEADING`
# @option opts [Symbol] :tracking token from `Base::TRACKING`
class Text < Box
  COMPONENT_OPTIONS = %i[size weight scheme font truncate variant leading tracking].freeze
  DEFAULT_TAG = :p

  # Named bundles of size/weight/scheme/leading so call sites reach for a
  # role instead of assembling arbitrary values:
  VARIANTS = {
    default: "",
    # Lead-in paragraph under a page/section header.
    lead: "text-[16.5px] leading-[1.65] max-w-[600px] text-pretty text-sage-11",
    # Secondary card/row description copy (project cards, pod taglines, talk abstracts).
    card_body: "text-[13.5px] leading-snug text-sage-11 text-pretty",
    # Dense mono chrome: dates, durations, tag chips, single-line row metadata.
    meta: "font-mono text-[11.5px] text-sage-11",
    # Trailing attribution line under long-form content (e.g. changelog source note).
    source_note: "mt-10 text-[12.5px] text-sage-11",
    # Uppercase mono section/group label (SectionHead, CollectionGroup year, TagCloud label).
    eyebrow: "font-mono text-xs uppercase tracking-[0.08em] text-sage-11",
    # List/row title (PostRow, MetaRow, PodRow, TalkCard, EpisodeCard) — serif,
    # medium weight, tokenized once so every row shares the same treatment,
    # including the group-hover-to-mint affordance for rows that are links.
    row_title: "text-[15px] font-medium leading-snug tracking-[-0.008em] text-sage-12 group-hover:text-mint-11 transition-colors",
    # Grid card title (ProjectCard, FeaturedCard) — serif, semibold, tighter tracking.
    card_title: "text-[15px] font-semibold tracking-tight text-sage-12"
  }.freeze

  private

  def classes
    c = []
    c << VARIANTS.fetch(opts.fetch(:variant, :default), VARIANTS[:default])
    c << TEXT_SIZES.fetch(opts[:size]&.to_sym, TEXT_SIZES[:none])
    c << TEXT_WEIGHT[opts[:weight]&.to_sym] if opts[:weight] && TEXT_WEIGHT.key?(opts[:weight]&.to_sym)
    c << TEXT_SCHEME[opts[:scheme]&.to_sym] if opts[:scheme] && TEXT_SCHEME.key?(opts[:scheme]&.to_sym)
    c << FONT_FAMILY[opts[:font]&.to_sym] if opts[:font] && FONT_FAMILY.key?(opts[:font]&.to_sym)
    c << LEADING[opts[:leading]&.to_sym] if opts[:leading] && LEADING.key?(opts[:leading]&.to_sym)
    c << TRACKING[opts[:tracking]&.to_sym] if opts[:tracking] && TRACKING.key?(opts[:tracking]&.to_sym)
    c << "truncate" if opts[:truncate]
    c
  end
end

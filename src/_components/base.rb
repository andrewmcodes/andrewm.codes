# Base class for design-system components.
#
# Provides shared token maps, option filtering, class composition, and small
# helpers used by atom, layout, and feature components.
class Base < Bridgetown::Component
  INVALID_ATTRIBUTES = [:as, :classes, :class_name].freeze
  COMPONENT_OPTIONS = [].freeze

  TEXT_WEIGHT = {
    light: "font-light",
    default: "font-normal",
    medium: "font-medium",
    semibold: "font-semibold",
    bold: "font-bold",
    extrabold: "font-extrabold",
    black: "font-black"
  }.freeze

  # Real scale (not an arbitrary-value grab bag) sized for Literata/Martian
  # Mono, which both run a touch larger than the previous sans/mono pairing
  # did at the same nominal size. Roles are intended usage, not hard rules:
  TEXT_SIZES = {
    none: "",
    xs2: "text-[11px]", # smallest meta labels: eyebrow/section labels, dense chrome
    xs: "text-xs", # meta labels: dates, tags, nav labels, kbd
    sm: "text-[13px]", # card body copy, secondary descriptions
    md: "text-sm", # default body-adjacent copy (component default)
    lg: "text-[15px]", # emphasized body copy, card titles
    xl: "text-base", # lead-in copy, pulled-up body text
    xl2: "text-[17px]" # lead paragraphs (matches prose :post body size)
  }.freeze

  TEXT_SCHEME = {
    default: "",
    subtle: "text-sage-10",
    muted: "text-sage-11",
    primary: "text-mint-11",
    strong: "text-sage-12",
    accent: "text-mint-11"
  }.freeze

  HEADING_SIZES = {
    xl: "text-4xl lg:text-5xl",
    lg: "text-3xl",
    md: "text-base",
    sm: "text-sm"
  }.freeze

  HEADING_SCHEME = {
    default: "text-sage-12",
    muted: "text-sage-11",
    accent: "text-mint-12"
  }.freeze

  FONT_FAMILY = {
    serif: "font-serif",
    sans: "font-sans",
    mono: "font-mono"
  }.freeze

  # Gap tokens shared by the one-axis layout primitives (Stack/Inline/Columns).
  # `sm2` (12px) exists because it's a real rhythm in the chrome (CTA rows,
  # footer link rows) that neither sm (8px) nor md (16px) reproduces.
  GAPS = {
    none: "",
    xs: "gap-1",
    sm: "gap-2",
    sm2: "gap-3",
    md: "gap-4",
    lg: "gap-6"
  }.freeze

  # Line-height tokens. Literata (serif body) wants more air than the
  # previous sans body did; Martian Mono chrome text stays tight/snug.
  LEADING = {
    tight: "leading-tight",
    snug: "leading-snug",
    normal: "leading-normal",
    relaxed: "leading-relaxed"
  }.freeze

  # Letter-spacing tokens, mainly for Martian Mono uppercase chrome labels
  # (it runs wide already, so `wide`/`wider` are used sparingly).
  TRACKING = {
    tight: "tracking-tight",
    normal: "tracking-normal",
    wide: "tracking-wide",
    wider: "tracking-wider"
  }.freeze

  def initialize(**opts)
    @opts = opts
    @attribute_opts = generate_attribute_opts(**opts)
    @site = Bridgetown::Current.site
  end

  private

  attr_reader :opts, :attribute_opts

  def generate_attribute_opts(**attrs)
    attrs.except(*[INVALID_ATTRIBUTES, self.class::COMPONENT_OPTIONS].compact.flatten)
  end

  def helper_opts
    attribute_opts
      .merge(**tag_opts)
      .merge(class: cx(classes, opts[:class_name], opts[:class]))
      .reject { |_, v| v.nil? || v == "" }
  end

  def tag_opts
    {}
  end

  def classes
    []
  end

  def children
    content
  end

  def cx(*classes)
    classes.flatten.compact.join(" ")
  end

  def slugify(str)
    str.to_s.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/^-|-$/, "")
  end
end

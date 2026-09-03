# Base class for design-system components.
#
# The system follows Braid's division of labour: **layout components own every
# unit of whitespace, and content components own none.** A `Text`, a `Heading`,
# an `Entry` or a `Tile` never sets its own margin — it is placed inside a
# `Stack` or an `Inline`, and that container decides how far it sits from its
# neighbour. This is why a page can be recomposed without hunting for the one
# component that brought its own `mt-4` along.
#
# Every token a component may spend is named here. Sizes are type roles from
# `@theme`, not raw scale steps; tones are semantic, not colour steps; space is
# a t-shirt scale, not a pixel value.
class Base < Bridgetown::Component
  INVALID_ATTRIBUTES = [:as, :classes, :class_name].freeze
  COMPONENT_OPTIONS = [].freeze

  # The one whitespace scale. `Stack` and `Inline` are the only components
  # allowed to spend it, which is what keeps vertical rhythm auditable: the
  # gaps on a page are a list of names, not forty margin utilities.
  SPACE = {
    none: "",
    xxs: "gap-1",     # 4px  — a label and the thing it labels
    xs: "gap-2",      # 8px  — glyphs in a row
    sm: "gap-3",      # 12px — items inside one control
    md: "gap-4",      # 16px — related lines
    lg: "gap-6",      # 24px — list items
    xl: "gap-8",      # 32px — blocks inside a section
    xxl: "gap-12",    # 48px — a section head and its list
    xxxl: "gap-14",   # 56px — between sections
    gutter: "gap-28"  # 112px — the hero and the body of the page
  }.freeze

  # Semantic tone, never a colour step. `secondary` is the workhorse: the hero
  # claim, every excerpt, all supporting copy and every measurement sit there,
  # which is what lets `neutral` mean "this wins the scan" without any rule
  # drawn around it.
  #
  # There is deliberately no step between `secondary` and `faint`. Mauve-10
  # measured 3.4:1 against the pane in dark and failed 4.5:1 for the 11–12.5px
  # sizes it was being used at, and a "quieter still" tone that only works at
  # large sizes is a trap in a system where almost all of it is small. Quiet is
  # carried by size and by the mono face, not by a third grey.
  TONE = {
    inherit: "",
    neutral: "text-mauve-12",
    secondary: "text-mauve-11",
    # Icons and glyphs only — never text. Non-text contrast needs 3:1, which
    # this clears in both themes; body text at this step does not.
    faint: "text-mauve-10",
    accent: "text-ruby-11"
  }.freeze

  TEXT_WEIGHT = {
    default: "font-normal",
    medium: "font-medium",
    semibold: "font-semibold",
    bold: "font-bold"
  }.freeze

  # Named type roles declared in `@theme`. Each carries its own leading,
  # tracking, and weight, so one class is the whole decision and the four
  # properties cannot drift apart across call sites.
  TEXT_SIZES = {
    none: "",
    micro: "text-micro",
    meta: "text-meta",
    label: "text-label",
    note: "text-note",
    body: "text-body",
    nav: "text-nav",
    row: "text-row",
    read: "text-read",
    lead: "text-lead"
  }.freeze

  HEADING_SIZES = {
    display: "text-display",
    headline: "text-headline",
    page: "text-page-title",
    h2: "text-h2",
    h3: "text-h3",
    row: "text-row"
  }.freeze

  # Two voices from one family: Geist Sans sets anything that is a sentence,
  # Geist Mono sets anything that is a measurement. There is no third.
  FONT_FAMILY = {
    sans: "font-sans",
    mono: "font-mono"
  }.freeze

  ALIGN = {
    start: "items-start",
    center: "items-center",
    baseline: "items-baseline",
    end: "items-end",
    stretch: "items-stretch"
  }.freeze

  JUSTIFY = {
    start: "justify-start",
    center: "justify-center",
    between: "justify-between",
    end: "justify-end"
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

  def token(map, key, fallback)
    map.fetch(key&.to_sym, map[fallback])
  end
end

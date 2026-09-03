# Base class for design-system components.
#
# Provides shared token maps, option filtering, class composition, and small
# helpers used by atom, layout, and feature components.
class Base < Bridgetown::Component
  INVALID_ATTRIBUTES = [:as, :classes, :class_name].freeze
  COMPONENT_OPTIONS = [].freeze

  TEXT_WEIGHT = {
    default: "font-normal",
    medium: "font-medium",
    semibold: "font-semibold",
    bold: "font-bold",
    extrabold: "font-extrabold",
    black: "font-black"
  }.freeze

  # Sizes are named type roles declared in `@theme`, not raw scale steps: each
  # one carries its own leading, tracking, and weight so the four decisions
  # cannot drift apart across components.
  TEXT_SIZES = {
    none: "",
    sm: "text-meta",
    md: "text-note",
    lg: "text-body",
    xl: "text-title"
  }.freeze

  TEXT_SCHEME = {
    default: "",
    muted: "text-slate-11",
    primary: "text-ruby-11",
    strong: "text-slate-12",
    accent: "text-ruby-11"
  }.freeze

  HEADING_SIZES = {
    xl: "text-display",
    lg: "text-headline",
    md: "text-page-title",
    sm: "text-title"
  }.freeze

  HEADING_SCHEME = {
    default: "text-slate-12",
    muted: "text-slate-11",
    accent: "text-ruby-12"
  }.freeze

  FONT_FAMILY = {
    sans: "font-sans",
    read: "font-read",
    mono: "font-mono"
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

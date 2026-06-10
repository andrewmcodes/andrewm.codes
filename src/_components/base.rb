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

  TEXT_SIZES = {
    none: "",
    sm: "text-xs",
    md: "text-sm",
    lg: "text-base",
    xl: "text-lg"
  }.freeze

  TEXT_SCHEME = {
    default: "",
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
    sans: "font-sans",
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

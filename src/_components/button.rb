# Tokenized button/link primitive.
#
# Use for controls and link-like actions that need button styling.
class Button < Base
  DEFAULT_TAG = :button
  COMPONENT_OPTIONS = %i[circle size variant href as type].freeze

  BUTTON_SIZES = {
    xs: {circular_spacing: "p-1", default_spacing: "py-1 px-2", text: "text-xs"},
    sm: {circular_spacing: "p-1", default_spacing: "py-1 px-2", text: "text-sm"},
    md: {circular_spacing: "p-1.5", default_spacing: "py-1.5 px-2.5", text: "text-sm"},
    lg: {circular_spacing: "p-2", default_spacing: "py-2 px-3", text: "text-sm"},
    xl: {circular_spacing: "p-2", default_spacing: "py-2.5 px-3.5", text: "text-sm"}
  }.freeze

  BUTTON_VARIANTS = {
    # Primary CTA. Bordered, sage at rest — mint is reserved for interactive
    # states (never a decorative fill), so mint only shows up on hover/focus.
    primary: "bg-transparent border border-sage-6 text-sage-12 hover:border-mint-9 hover:text-mint-11 transition-colors",
    # Secondary CTA. Neutral bordered sage surface.
    secondary: "bg-sage-3 hover:bg-sage-4 text-sage-12 border border-sage-5 transition-colors",
    # Low-emphasis control. No border, subtle hover fill.
    ghost: "bg-transparent hover:bg-sage-3 text-sage-11 transition-colors",
    # Bare text control. No border, no fill.
    text: "bg-transparent text-sage-11",
    # Inline share affordance styled like an underline-meta link rather than
    # button chrome (see ShareButton).
    share: "inline-flex items-center gap-1.5 font-mono text-[11.5px] text-sage-11 border-b border-sage-5 pb-0.5 hover:text-mint-11 hover:border-mint-11 transition-colors bg-transparent"
  }.freeze

  def call
    attrs = html_attributes(**helper_opts, prefix_space: true)
    inner = children.to_s
    html -> { "<#{tag_name}#{attrs}>#{inner}</#{tag_name}>" }
  end

  private

  def size
    BUTTON_SIZES.key?(opts[:size]) ? opts[:size] : :md
  end

  def variant
    BUTTON_VARIANTS.key?(opts[:variant]) ? opts[:variant] : :secondary
  end

  def classes
    cx(
      BUTTON_VARIANTS[variant],
      (BUTTON_SIZES[size][:circular_spacing] if opts[:circle] && variant != :share),
      (BUTTON_SIZES[size][:default_spacing] unless opts[:circle] || variant == :share),
      BUTTON_SIZES[size][:text],
      ((opts[:circle] ? "rounded-full" : "rounded-md") unless variant == :share),
      ((variant == :share) ? nil : cx("group inline-flex items-center justify-center leading-none font-medium", FONT_FAMILY[:mono])),
      "focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-mint-9"
    )
  end

  def tag_name
    return :a if opts[:href]
    opts.fetch(:as, DEFAULT_TAG).to_sym
  end

  def tag_opts
    return {href: opts[:href]} if opts[:href]
    {type: opts.fetch(:type, "button")}
  end
end

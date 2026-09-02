# Tokenized button/link primitive.
#
# Use for controls and link-like actions that need button styling.
class Button < Base
  DEFAULT_TAG = :button
  COMPONENT_OPTIONS = %i[circle size variant href as type].freeze

  # The scale is padding, not type: everything above `sm` shares one size so a
  # row of buttons reads as one control family.
  BUTTON_SIZES = {
    xs: {circular_spacing: "p-1", default_spacing: "py-1 px-2", text: "text-meta"},
    sm: {circular_spacing: "p-1", default_spacing: "py-1 px-2", text: "text-meta"},
    md: {circular_spacing: "p-1.5", default_spacing: "py-1.5 px-2.5", text: "text-note"},
    lg: {circular_spacing: "p-2", default_spacing: "py-2 px-3", text: "text-note"},
    xl: {circular_spacing: "p-2", default_spacing: "py-2.5 px-3.5", text: "text-note"}
  }.freeze

  # The accent marks state, so the resting primary action is a ruby hairline
  # and a ruby label rather than a ruby field. The solid fill it replaces put
  # white on ruby-9 at 3.89:1 — under the 4.5:1 its 13.5px label needs — and
  # was the most landing-page-shaped object on the site. This measures 5.16:1
  # in light and 8.36:1 in dark, and the fill still arrives on hover.
  BUTTON_VARIANTS = {
    primary: "bg-slate-2 hover:bg-ruby-3 border border-ruby-9/50 hover:border-ruby-9 text-ruby-11 font-medium",
    # A hairline, not a field. Once the primary stopped being a solid fill, a
    # filled slate-3 secondary was the heaviest object in the hero and the
    # emphasis inverted — the ruby outline has to lead.
    secondary: "bg-transparent border border-slate-6 hover:bg-slate-3 hover:border-slate-7 text-slate-12",
    ghost: "bg-transparent hover:bg-slate-3 text-slate-11",
    text: "bg-transparent text-slate-11",
    share: "inline-flex items-center gap-1.5 font-mono text-meta text-slate-10 border-b border-slate-5 pb-0.5 hover:text-ruby-11 hover:border-ruby-11 transition-colors bg-transparent"
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
      ((variant == :share) ? nil : "inline-flex items-center justify-center leading-none font-medium"),
      "focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-ruby-9"
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

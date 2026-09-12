# Horizontal layout primitive. The inline-axis counterpart to `Stack`, and the
# only component allowed to put space between siblings across a row.
#
# Wraps by default: a row of tags, glyphs, or actions has to survive a narrow
# pane without the caller adding responsive classes at the call site.
#
# @option opts [Symbol] :space (`:sm`) one of `Base::SPACE`
# @option opts [Symbol] :align (`:center`) one of `Base::ALIGN`
# @option opts [Symbol] :justify one of `Base::JUSTIFY`
# @option opts [Boolean] :nowrap keep the row on one line
class Inline < Box
  COMPONENT_OPTIONS = %i[space align justify nowrap].freeze

  private

  def classes
    cx(
      "flex",
      opts[:nowrap] ? "flex-nowrap min-w-0" : "flex-wrap",
      token(SPACE, opts[:space], :sm),
      token(ALIGN, opts[:align], :center),
      (token(JUSTIFY, opts[:justify], :start) if opts[:justify])
    )
  end
end

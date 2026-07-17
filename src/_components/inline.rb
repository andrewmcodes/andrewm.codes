# Horizontal flex-row layout primitive for one-dimensional content flows.
#
# Use `Inline` for a row of items (icon + label, meta chips, button groups)
# that should share a simple gap rhythm without page-local Tailwind classes.
# Pairs with {Stack} (vertical) as the other half of the one-axis primitives.
#
# @option opts [Symbol] :gap (`:none`) one of `GAPS` (same scale as {Stack})
# @option opts [Symbol] :align (`:center`) one of `ALIGN`
# @option opts [Boolean] :wrap (`true`) whether the row wraps to multiple lines
class Inline < Box
  COMPONENT_OPTIONS = %i[gap align wrap].freeze

  ALIGN = {
    baseline: "items-baseline",
    center: "items-center",
    start: "items-start"
  }.freeze

  private

  def classes
    cx(
      "flex flex-row",
      GAPS.fetch(opts.fetch(:gap, :none), GAPS[:none]),
      ALIGN.fetch(opts.fetch(:align, :center), ALIGN[:center]),
      (opts.fetch(:wrap, true) ? "flex-wrap" : "flex-nowrap")
    )
  end
end

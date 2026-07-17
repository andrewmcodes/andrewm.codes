# Vertical stack layout primitive for one-dimensional content flows.
#
# Use `Stack` in pages and layouts when repeated rows should share a simple
# column rhythm without page-local Tailwind classes.
#
# @option opts [Symbol] :gap (`:none`) one of `GAPS`
class Stack < Box
  COMPONENT_OPTIONS = %i[gap].freeze

  private

  def classes
    cx("flex flex-col", GAPS.fetch(opts.fetch(:gap, :none), GAPS[:none]))
  end
end

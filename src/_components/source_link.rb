# One row in the source list.
#
# The current row is marked three ways, none of them a hue on its own: a filled
# field, a weight step, and a ruby bar in the row's own left edge. Colour is the
# reinforcement, never the distinction — which is the whole reason a colour-blind
# reader and a keyboard reader see the same state.
class SourceLink < Bridgetown::Component
  # @param label [String] the view's name
  # @param href [String] its path
  # @param icon [String, nil] a `src/images/*.svg` name
  # @param current [Boolean] whether this is the view being shown
  # @param external [Boolean] whether following it leaves the site
  # @param size [Symbol] `:nav` in the rail, `:drawer` at a touch target
  def initialize(label:, href:, icon: nil, current: false, external: false, size: :nav)
    @label = label
    @href = href
    @icon = icon
    @current = current
    @external = external
    @size = size
  end

  attr_reader :label, :href, :icon

  def current? = @current

  def external? = @external

  def row_classes
    [
      "group relative flex items-center gap-2.5 rounded-md transition-colors",
      (@size == :drawer) ? "px-3 py-2.5 text-body" : "px-3 py-1.5 text-nav",
      if current?
        "bg-mauve-4 text-mauve-12 font-semibold"
      else
        "text-mauve-11 hover:bg-mauve-3 hover:text-mauve-12"
      end
    ].join(" ")
  end
end

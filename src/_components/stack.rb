# Vertical layout primitive. The only component allowed to put space between
# siblings on the block axis.
#
# Content components bring no margin of their own, so a `Stack` is the whole
# vertical rhythm decision for its children: change `space:` and the region
# recomposes, with nothing left behind in a child's class list.
#
# @option opts [Symbol] :space (`:none`) one of `Base::SPACE`
# @option opts [Symbol] :align cross-axis alignment, one of `Base::ALIGN`
# @option opts [Boolean] :divide draw a hairline between children
class Stack < Box
  COMPONENT_OPTIONS = %i[space align divide].freeze

  private

  def classes
    cx(
      "flex flex-col",
      token(SPACE, opts[:space], :none),
      (token(ALIGN, opts[:align], :stretch) if opts[:align]),
      ("divide-y divide-mauve-6" if opts[:divide])
    )
  end
end

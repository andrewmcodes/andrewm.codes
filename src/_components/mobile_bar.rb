# The source list folded into a bar, below `shell`.
#
# Same views, same order, same you-are-here marks. The drawer is toggled by
# `data-open` rather than `hidden` so the transition can run, and is `inert`
# while closed so its links stay out of the tab order.
class MobileBar < Bridgetown::Component
  include SourceNav

  def initialize(resource: nil)
    @resource = resource
  end

  attr_reader :resource
end

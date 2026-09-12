# The persistent source list: the app's own views above, the places it leaves
# for below, and the two controls that are always available at the foot.
#
# It carries `view-transition-name: source-list` (see `index.css`), so it does
# not cross-fade between navigations. The pane swaps and the rail holds still,
# which is the difference between an app changing view and a document reloading.
class SourceList < Bridgetown::Component
  include SourceNav

  def initialize(resource: nil)
    @resource = resource
  end

  attr_reader :resource
end

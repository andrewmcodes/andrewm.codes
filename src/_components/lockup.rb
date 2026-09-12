# The identity lockup: avatar, name, handle. Links home.
#
# Two sizes, one drawing. `:rail` sits at the head of the source list; `:bar`
# sits in the mobile bar, where the handle drops below `compact` because a
# 44px touch target and a wordmark cannot both have the width.
class Lockup < Bridgetown::Component
  SIZES = {
    rail: {avatar: "w-8 h-8", name: "text-nav", gap: "gap-2.5"},
    bar: {avatar: "w-7 h-7", name: "text-nav", gap: "gap-2.5"}
  }.freeze

  def initialize(size: :rail)
    @size = SIZES.key?(size) ? size : :rail
    @site = Bridgetown::Current.site
  end

  def tokens = SIZES[@size]

  def handle = @site.metadata.handle
end

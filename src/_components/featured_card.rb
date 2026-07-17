# Card highlighting a featured proof point (work, open source, podcast, writing).
#
# Reads a plain hash from `src/_data/featured.yml` so the homepage owns the
# content while the design system owns the treatment.
class FeaturedCard < Base
  CARD_CLASSES = "group flex flex-col gap-1 bg-sage-1 hover:bg-sage-2 transition-colors py-3.5 md:p-5"
  KIND_BADGE_CLASSES = "ml-auto rounded-full border border-sage-4 px-1.5 py-px"

  # @param item [Hash] a featured item from `src/_data/featured.yml`
  def initialize(item:)
    @item = item
    super()
  end

  # Reads a field by either string or symbol key.
  # @param key [String, Symbol] the field name
  # @return [Object, nil] the value, or nil if absent
  def field(key)
    @item[key.to_s] || @item[key.to_sym]
  end

  # Shared with {ProjectCard} so the two card shapes read as one system.
  def card_classes
    CARD_CLASSES
  end

  def kind_badge_classes
    KIND_BADGE_CLASSES
  end
end

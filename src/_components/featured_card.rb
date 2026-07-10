# Card highlighting a featured proof point (work, open source, podcast, writing).
#
# Reads a plain hash from `src/_data/featured.yml` so the homepage owns the
# content while the design system owns the treatment.
class FeaturedCard < Bridgetown::Component
  # @param item [Hash] a featured item from `src/_data/featured.yml`
  def initialize(item:)
    @item = item
  end

  # Reads a field by either string or symbol key.
  # @param key [String, Symbol] the field name
  # @return [Object, nil] the value, or nil if absent
  def field(key)
    @item[key.to_s] || @item[key.to_sym]
  end
end

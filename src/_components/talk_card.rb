# Talk list row with event metadata, abstract, and resource links.
class TalkCard < Base
  ROW_CLASSES = "grid grid-cols-[96px_1fr] gap-5 py-5 border-b border-sage-4 max-sm:grid-cols-1 max-sm:gap-2 max-sm:py-4"

  # @param talk [Hash] talk data from `src/_data/talks.yml`
  def initialize(talk:)
    @talk = talk
    super()
  end

  # @return [String] the talk date formatted "Mon D, YYYY", or "" if missing
  #   or unparseable
  def date_str
    d = @talk["date"] || @talk[:date]
    return "" unless d
    parsed = d.is_a?(String) ? Date.parse(d) : d
    parsed.strftime("%b %-d, %Y")
  rescue ArgumentError, TypeError
    ""
  end

  # Reads a talk field by either string or symbol key.
  # @param key [String, Symbol] the field name
  # @return [Object, nil] the value, or nil if absent
  def field(key)
    @talk[key.to_s] || @talk[key.to_sym]
  end

  # 96px standard, matching PostRow/MetaRow (was 120px).
  def row_classes
    ROW_CLASSES
  end

  # @return [String, nil] "venue · city", venue only, or nil
  def venue_line
    return field(:venue) unless field(:city)
    "#{field(:venue)} · #{field(:city)}"
  end

  # @return [Array<Hash>] normalized {href:, label:} resource links
  def links
    Array(field(:links)).map { |l| {href: l["href"] || l[:href], label: l["label"] || l[:label]} }
  end

  # @return [String] classes for a mono resource link (kept off Link's own
  #   :inline variant, which is sage-12 — this reads as secondary/sage-11).
  def resource_link_classes
    cx(
      "inline-flex items-center gap-1 pb-px border-b border-sage-5 transition-colors hover:text-mint-11 hover:border-mint-11",
      FONT_FAMILY[:mono],
      TEXT_SIZES[:xs],
      TEXT_SCHEME[:muted]
    )
  end
end

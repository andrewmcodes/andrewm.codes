# The site's one chronological row.
#
# A post, a talk, an episode, a show, and a link are the same object here: a
# lead column of measurement, a title carrying its own facts, and an optional
# trailing note. Density decides how much room one entry gets — never what it
# is made of — which is what lets writing, speaking, and podcasting read as one
# body of work rather than four lists that merely resemble each other.
class Entry < Bridgetown::Component
  DENSITIES = {
    # Scanning a year of writing: date, title, facts, arrow. The lead column is
    # 168px to land in the same margin `PageSection` puts its labels in —
    # at 96px the archive quietly used a second grid and the site's one
    # compositional idea broke on the page where it should be clearest.
    compact: {
      cols: "grid-cols-[168px_1fr_auto]",
      spacing: "gap-10 py-3.5",
      align: "items-baseline",
      bleed: false
    },
    # One item given room to argue for itself: kicker, title, excerpt, links.
    full: {
      cols: "grid-cols-[120px_1fr]",
      spacing: "gap-5 py-5",
      align: "items-baseline",
      bleed: true
    },
    # A show or anything else fronted by artwork rather than a date.
    media: {
      cols: "grid-cols-[64px_1fr_auto]",
      spacing: "gap-5 py-[18px]",
      align: "items-center",
      bleed: true
    }
  }.freeze

  # Collapse to a single column early; the lead column is measurement, and on a
  # phone it belongs above the title rather than beside it.
  STACK = {
    compact: "max-md:grid-cols-1 max-md:gap-1.5",
    full: "max-sm:grid-cols-1 max-sm:gap-2 max-sm:py-4",
    media: "max-sm:grid-cols-1 max-sm:items-start max-sm:gap-3.5"
  }.freeze

  # @param title [String] the entry's own name
  # @param href [String, nil] destination; nil renders an inert row
  # @param density [Symbol] one of `DENSITIES`
  # @param lead [String, nil] left column primary line, usually a date
  # @param lead_sub [String, nil] left column secondary line, usually a duration
  # @param mark [Hash, nil] artwork for `:media` — `{label:, hue:, image:, dim:}`
  # @param excerpt [String, nil] one paragraph of supporting copy
  # @param tags [Array<String>] hash-prefixed tags
  # @param meta [Array<String>] mono facts joined by a middot
  # @param trailing [String, nil] right column note
  # @param links [Array<Hash>] `{label:, href:}` actions below the excerpt
  # @param data [Hash] extra data attributes for the row element
  # There is deliberately no kicker. A small accent line above a title is an
  # eyebrow, and the show or venue it carried is a fact about the item, not a
  # heading over it — those belong in `meta` with the other facts.
  def initialize(title:, href: nil, external: false, density: :compact,
    lead: nil, lead_sub: nil, mark: nil, excerpt: nil,
    tags: [], meta: [], trailing: nil, links: [], title_icon: false, data: {})
    @title = title
    @href = href
    @external = external
    @density = DENSITIES.key?(density) ? density : :compact
    @lead = lead
    @lead_sub = lead_sub
    @mark = mark
    @excerpt = excerpt
    @tags = Array(tags)
    @meta = Array(meta).reject { |v| v.nil? || v.to_s.strip.empty? }
    @trailing = trailing
    @links = Array(links)
    @title_icon = title_icon
    @data = data
  end

  attr_reader :title, :href, :lead, :lead_sub, :mark, :excerpt,
    :tags, :meta, :trailing, :links, :data

  def linked? = !href.nil? && href.to_s != "" && href.to_s != "#"

  def external? = @external

  def title_icon? = @title_icon

  def icon_name = external? ? "arrow_top_right" : "arrow_right"

  def tokens = DENSITIES[@density]

  # A row with nothing in its lead column must not reserve one. Inside a
  # `PageSection` the 168px lead lands in the same margin as the section label,
  # which is the point on the archive — but where a section already owns that
  # margin, keeping it opens a second rail inside the first and the page grows
  # a third left edge.
  def lead_column? = !mark.nil? || !lead.nil?

  def columns
    return tokens[:cols] if lead_column?

    three_column? ? "grid-cols-[1fr_auto]" : "grid-cols-1"
  end

  def three_column? = @density != :full

  # The hover surface bleeds past the text so a row tints without becoming a
  # box — the separator stays the hairline, not a border on a card.
  def row_classes
    [
      "group relative grid",
      columns,
      tokens[:spacing],
      tokens[:align],
      "border-b border-slate-6",
      (STACK[@density] if lead_column?),
      (bleed_classes if tokens[:bleed] && linked?)
    ].compact.join(" ")
  end

  private

  def bleed_classes
    "before:absolute before:-inset-x-3 before:inset-y-1 before:-z-10 " \
      "before:rounded-md before:bg-transparent before:transition-colors " \
      "hover:before:bg-slate-2"
  end
end

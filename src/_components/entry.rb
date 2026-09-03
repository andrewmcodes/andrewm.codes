# The site's one list row.
#
# A post, a talk, an episode, a show, and a link are the same object here: a
# large semibold title carrying its own facts, with measurement demoted to the
# right edge or to the line below. Density decides how much room one entry gets
# — never what it is made of — which is what lets writing, speaking, and
# podcasting read as one body of work rather than four lists that resemble each
# other.
#
# There is no rule under a row and no arrow at rest. Rows are separated by the
# `Stack` around them; the row you are pointing at is marked the same way the
# source list marks the view you are on — a filled field and a ruby bar in its
# own left edge. One mark, two places, so a list learns nothing new.
class Entry < Bridgetown::Component
  DENSITIES = {
    # Scanning a body of work: title, an optional date at the right edge.
    compact: {stack: false, mark: nil, align: "items-baseline"},
    # One item given room to argue for itself: title, excerpt, facts, links.
    full: {stack: true, mark: nil, align: "items-baseline"},
    # Anything fronted by artwork rather than a date.
    media: {stack: true, mark: "w-12 h-12", align: "items-center"}
  }.freeze

  # @param title [String] the entry's own name
  # @param href [String, nil] destination; nil renders an inert row
  # @param density [Symbol] one of `DENSITIES`
  # @param lead [String, nil] a date or other measurement; sits at the right
  #   edge in `compact` and under the title elsewhere
  # @param lead_sub [String, nil] a second measurement, usually a duration
  # @param mark [Hash, nil] artwork for `:media` — `{label:, hue:, image:, dim:}`
  # @param excerpt [String, nil] one paragraph of supporting copy
  # @param tags [Array<String>] hash-prefixed tags
  # @param meta [Array<String>] mono facts joined by a middot
  # @param trailing [String, nil] right-edge note, overriding `lead`
  # @param links [Array<Hash>] `{label:, href:, external:}` actions
  # @param clamp_title [Boolean] hold the title to one line, ellipsised. For a
  #   list that is an aside to something else rather than the thing being
  #   scanned — a wrapped title there buys nothing and costs the even row
  #   rhythm the block is there to provide.
  def initialize(title:, href: nil, external: false, density: :compact,
    lead: nil, lead_sub: nil, mark: nil, excerpt: nil,
    tags: [], meta: [], trailing: nil, links: [], title_icon: false,
    clamp_title: false, data: {})
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
    @clamp_title = clamp_title
    @data = data
  end

  attr_reader :title, :href, :lead, :lead_sub, :mark, :excerpt,
    :tags, :meta, :links, :data

  def linked? = !href.nil? && href.to_s != "" && href.to_s != "#"

  def external? = @external

  def title_icon? = @title_icon || external?

  def clamp_title? = @clamp_title

  # `truncate` rather than `line-clamp-1`: line-clamp swaps the span to
  # `-webkit-box`, which drops it out of the baseline the edge-note date is
  # aligned to.
  def title_classes
    clamp_title? ? "min-w-0 truncate" : "text-pretty"
  end

  def tokens = DENSITIES[@density]

  def compact? = @density == :compact

  def media? = @density == :media

  # In `compact` the measurement moves to the right edge; everywhere else the
  # row is already stacked and it joins the facts under the title.
  def edge_note = @trailing || (compact? ? lead : nil)

  # Facts under the title. In a stacked density the date is one of them, which
  # is why it is not repeated at the edge.
  def stacked_facts
    return meta if compact?

    [lead, lead_sub, *meta].compact.reject { |v| v.to_s.strip.empty? }
  end

  def row_classes
    [
      "group relative block rounded-lg -mx-3 px-3 py-2 transition-colors",
      ("hover:bg-mauve-3 focus-visible:bg-mauve-3" if linked?),
      (accent_bar if linked?)
    ].compact.join(" ")
  end

  private

  # The same mark the source list puts beside the current view. Pointing at a
  # row and standing on a view say the same thing in the same shape, so the
  # accent never has to be learned twice.
  def accent_bar
    "before:absolute before:left-0 before:top-2.5 before:bottom-2.5 before:w-0.5 " \
      "before:rounded-full before:bg-ruby-11 before:opacity-0 " \
      "before:transition-opacity hover:before:opacity-100 " \
      "focus-visible:before:opacity-100"
  end
end

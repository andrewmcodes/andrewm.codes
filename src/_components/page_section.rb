# A major page section: its label hanging in the left margin, and the content
# in its own column.
#
# This is the site's one compositional idea on desktop. Apparatus — what a
# section is called, what it contains, where the rest of it lives — sits in the
# margin, and the column beside it carries nothing but the work. Below `nav`
# the two streams stack, because a 168px margin is a luxury a phone does not
# have.
class PageSection < Bridgetown::Component
  # `home_coda` binds a section tightly to the hero above it and opens a large
  # gap below, so the homepage reads as a peak followed by an even body rather
  # than as six sections at identical pitch.
  # Separation is space, not a line. The section rule was doing work the gap
  # already does, and with one on every section the page read as a stack of
  # ruled boxes; these steps are the compensation for taking it out.
  SPACING = {
    default: "mb-24",
    home: "pb-20",
    home_first: "pt-12 pb-20",
    home_coda: "pt-2 pb-28",
    none: ""
  }.freeze

  RAIL = "grid grid-cols-[168px_minmax(0,1fr)] gap-10 max-nav:grid-cols-1 max-nav:gap-0"

  # @param label [String, nil] the section's name; nil renders content alone
  # @param description [String, nil] one line on what the section holds
  # @param link_label [String, nil] label for the "everything else" action
  # @param link_href [String, nil] destination for that action
  # @param spacing [Symbol] one of `SPACING`
  def initialize(label: nil, description: nil, link_label: nil, link_href: nil, spacing: :default)
    @label = label
    @description = description
    @link_label = link_label
    @link_href = link_href
    @spacing = spacing
  end

  attr_reader :label, :description, :link_label, :link_href

  def labelled? = !label.nil?

  def link? = !link_label.nil? && !link_href.nil?

  def icon_name = link_href.to_s.start_with?("http") ? "arrow_top_right" : "arrow_right"

  def section_classes
    [
      SPACING.fetch(@spacing, SPACING[:default]),
      (labelled? ? RAIL : nil)
    ].compact.join(" ")
  end
end

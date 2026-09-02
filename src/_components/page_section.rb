# Layout wrapper for major page sections.
#
# @option opts [Symbol] :spacing (`:default`) one of `SPACING`
class PageSection < Box
  COMPONENT_OPTIONS = %i[spacing].freeze
  DEFAULT_TAG = :section

  # `home_coda` binds a section tightly to the hero above it and opens a large
  # gap below, so the homepage reads as a peak followed by an even body rather
  # than as six sections at identical pitch.
  SPACING = {
    default: "mb-14",
    home: "pb-12",
    home_first: "pt-12 pb-12",
    home_coda: "pt-2 pb-20",
    none: ""
  }.freeze

  private

  def classes
    cx(SPACING.fetch(opts.fetch(:spacing, :default), SPACING[:default]))
  end
end

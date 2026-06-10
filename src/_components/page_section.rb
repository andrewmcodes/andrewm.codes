# Layout wrapper for major page sections.
#
# @option opts [Symbol] :spacing (`:default`) one of `SPACING`
class PageSection < Box
  COMPONENT_OPTIONS = %i[spacing].freeze
  DEFAULT_TAG = :section

  SPACING = {
    default: "mb-14",
    home: "pb-12",
    home_first: "pt-12 pb-12",
    none: ""
  }.freeze

  private

  def classes
    cx(SPACING.fetch(opts.fetch(:spacing, :default), SPACING[:default]))
  end
end

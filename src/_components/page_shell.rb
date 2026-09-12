# Vertical spacing for one view inside the pane.
#
# The pane owns the measure and the horizontal gutter — one width for every
# surface, so the source list, the reading column and every index share a left
# edge. All this component decides is how much air a view opens and closes on.
#
# @option opts [Symbol] :spacing (`:default`) one of `SPACING`
class PageShell < Box
  COMPONENT_OPTIONS = %i[width spacing].freeze

  SPACING = {
    default: "py-14 shell:py-20",
    # The homepage opens higher and closes tighter: its own hero already
    # carries the top air, and the footer sits right under the last list.
    home: "pt-16 shell:pt-24 pb-16",
    none: ""
  }.freeze

  private

  def classes
    cx("w-full", token(SPACING, opts[:spacing], :default))
  end
end

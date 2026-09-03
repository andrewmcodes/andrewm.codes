# Responsive page-width and vertical-spacing wrapper for top-level pages/layouts.
#
# @option opts [Symbol] :width (`:wide`) one of `WIDTHS`
# @option opts [Symbol] :spacing (`:default`) one of `SPACING`
class PageShell < Box
  COMPONENT_OPTIONS = %i[width spacing].freeze

  # One measure for every page, so the topbar, the content, and the footer
  # share a left edge on every surface. The three widths used to diverge and
  # `narrow` put a page title 176px right of the wordmark above it. Column
  # width is now `max-w-prose`'s job alone: at 1080 the reading grid leaves
  # 744px beside the rail, so 65ch of the reading face binds first — which is
  # the constraint that matters, and the one that broke when the shell was
  # sized in pixels against a face that has since changed.
  WIDTHS = {
    wide: "max-w-[1080px] px-9 max-md:px-4",
    reading: "max-w-[1080px] px-9 max-md:px-4",
    narrow: "max-w-[1080px] px-9 max-md:px-4"
  }.freeze

  SPACING = {
    default: "py-16 pb-24",
    home: "",
    none: ""
  }.freeze

  private

  def classes
    cx(
      WIDTHS.fetch(opts.fetch(:width, :wide), WIDTHS[:wide]),
      SPACING.fetch(opts.fetch(:spacing, :default), SPACING[:default]),
      "mx-auto w-full"
    )
  end
end

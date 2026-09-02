# Responsive page-width and vertical-spacing wrapper for top-level pages/layouts.
#
# @option opts [Symbol] :width (`:wide`) one of `WIDTHS`
# @option opts [Symbol] :spacing (`:default`) one of `SPACING`
class PageShell < Box
  COMPONENT_OPTIONS = %i[width spacing].freeze

  WIDTHS = {
    wide: "max-w-[1080px] px-9 max-md:px-4",
    # Wide enough to hold the apparatus in the margin and still leave the
    # column room for a full 65ch measure. At 940px the grid column, not
    # `max-w-prose`, was the binding constraint and the measure fell to 63ch
    # when the body went to 18px.
    reading: "max-w-[980px] px-9 max-md:px-4",
    narrow: "max-w-[720px] px-8 max-md:px-4"
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

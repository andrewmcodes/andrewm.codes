# The site's one grid cell, for peers rather than chronology.
#
# A tile is what an entry is not: projects and featured work have no meaningful
# order, so they tile as equals and carry no date. Anything dated belongs in an
# `Entry`, and a grid never carries dated content.
#
# Facts that belong at the bottom are passed as the block, pinned with
# `mt-auto` so a row of unequal tiles still aligns its footers.
class Tile < Bridgetown::Component
  # @param title [String] the thing's name
  # @param href [String] destination
  # @param desc [String, nil] one paragraph of supporting copy
  # @param chip [String, nil] a short kind or status, set to the row's right
  # @param chip_accent [Boolean] whether the chip carries the accent
  def initialize(title:, href:, external: true, desc: nil, chip: nil, chip_accent: false)
    @title = title
    @href = href
    @external = external
    @desc = desc
    @chip = chip
    @chip_accent = chip_accent
  end

  attr_reader :title, :href, :desc, :chip

  def external? = @external

  def chip_classes
    accent = @chip_accent ? "text-ruby-11" : "text-mauve-11"
    "ml-auto shrink-0 font-mono text-micro uppercase #{accent}"
  end

  # The same field, radius, and ruby edge bar an `Entry` uses. One hover
  # language, so pointing at a project and pointing at a post feel identical —
  # the tile only differs in shape, never in how it answers the pointer.
  def tile_classes
    "group relative flex flex-col rounded-lg -mx-4 px-4 py-3.5 " \
      "transition-colors hover:bg-mauve-3 focus-visible:bg-mauve-3 " \
      "before:absolute before:left-0 before:top-3 before:bottom-3 before:w-0.5 " \
      "before:rounded-full before:bg-ruby-11 before:opacity-0 " \
      "before:transition-opacity hover:before:opacity-100 focus-visible:before:opacity-100"
  end
end

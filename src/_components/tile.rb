# The site's one grid cell, for peers rather than chronology.
#
# A tile is what an entry is not: projects and featured work have no meaningful
# order, so they tile as equals. Anything dated belongs in an `Entry`. The cell
# is a region bounded by the grid's hairlines, never a box of its own — the
# card grid draws its rules on the children so an odd count cannot leave a
# stray filled cell behind.
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
    accent = @chip_accent ? "text-ruby-11" : "text-slate-10"
    "ml-auto font-mono text-micro uppercase #{accent}"
  end
end

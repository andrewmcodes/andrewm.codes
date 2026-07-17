# Podcast list row with optional cover art and role metadata.
class PodRow < Base
  # @param pod [Hash] podcast data from `src/_data/podcasts.yml`
  def initialize(pod:)
    @pod = pod
    super()
  end

  def field(key)
    @pod[key.to_s] || @pod[key.to_sym]
  end

  def hue
    field(:accent_hue) || 180
  end

  def url
    field(:url)
  end

  def linked?
    url.to_s != "" && url.to_s != "#"
  end

  # @return [String] grid template (Columns' shared 64px `:media_row`) plus
  #   the row's own gap/border/hover chrome. Hover highlight and the `group`
  #   marker are only present when the row is actually a link, so unlinked
  #   rows don't imply interactivity they don't have.
  def row_classes
    cx(
      (linked? ? "group" : nil),
      "relative items-center gap-5 py-[18px] border-b border-sage-4 max-sm:items-start max-sm:gap-3.5",
      Columns::TEMPLATES[:media_row],
      "max-sm:grid-cols-1",
      (linked? ? "before:absolute before:-inset-x-3 before:inset-y-1 before:-z-10 before:rounded-md before:bg-transparent before:transition-colors hover:before:bg-sage-2" : nil)
    )
  end

  # @return [String, nil] "since <date>" when active, the raw date otherwise
  def since_label
    return nil unless field(:since)
    field(:active) ? "since #{field(:since)}" : field(:since)
  end

  # @return [Array<String>] the non-nil since/schedule chips
  def meta_parts
    [since_label, field(:schedule)].compact
  end
end

# Podcast list row with optional cover art and role metadata.
class PodRow < Bridgetown::Component
  # @param pod [Hash] podcast data from `src/_data/podcasts.yml`
  def initialize(pod:)
    @pod = pod
  end

  def field(key)
    @pod[key.to_s] || @pod[key.to_sym]
  end

  def hue
    field(:accent_hue) || 180
  end

  # A show with no real link renders as an inert row rather than a dead anchor.
  def listen_url
    url = field(:url).to_s
    (url.empty? || url == "#") ? nil : url
  end

  def facts
    [since_label, field(:schedule)].compact
  end

  private

  # A running show says "since 2019"; a finished one just states the year.
  def since_label
    since = field(:since)
    return nil unless since
    field(:active) ? "since #{since}" : since.to_s
  end
end

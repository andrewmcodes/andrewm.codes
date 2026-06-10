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
end

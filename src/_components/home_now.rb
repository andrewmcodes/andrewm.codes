# Compact "currently" strip of the freshest real-world signals.
#
# Surfaces active work (role, latest podcast episode, most recent talk) so the
# homepage shows current momentum instead of leaning on blog post dates, which
# can read as stale even when the work behind the scenes is active.
class HomeNow < Bridgetown::Component
  # @param episode [Hash, nil] latest episode data (`site.data.remote_ruby`)
  # @param talk [Hash, nil] most recent talk from `src/_data/talks.yml`
  def initialize(episode:, talk:)
    @episode = episode
    @talk = talk
  end

  # @return [String, nil] the episode listen URL
  def episode_url
    @episode && @episode["url"]
  end

  # @return [String, nil] the episode publish month, e.g. "Jul 2026"
  def episode_date
    raw = @episode && @episode["published_at"]
    return nil unless raw
    Date.parse(raw.to_s).strftime("%b %Y")
  rescue ArgumentError, TypeError
    nil
  end

  # Reads a talk field by either string or symbol key.
  # @param key [String, Symbol] the field name
  # @return [Object, nil] the value, or nil if absent
  def talk_field(key)
    return nil unless @talk
    @talk[key.to_s] || @talk[key.to_sym]
  end

  # @return [String, nil] the talk month, e.g. "Jun 2026"
  def talk_date
    d = talk_field(:date)
    return nil unless d
    (d.is_a?(String) ? Date.parse(d) : d).strftime("%b %Y")
  rescue ArgumentError, TypeError
    nil
  end
end

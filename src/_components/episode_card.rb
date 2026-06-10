# Row card for the latest podcast episode data.
class EpisodeCard < Bridgetown::Component
  # @param episode [Hash] normalized episode data from `remote_ruby.json`
  def initialize(episode:)
    @episode = episode
  end

  # @return [String, nil] the episode title
  def title
    @episode["title"]
  end

  # @return [String, nil] the episode listen URL
  def url
    @episode["url"]
  end

  # @return [Integer, nil] the episode number
  def episode_number
    @episode["episode_number"]
  end

  # @return [String] the publish date formatted "Mon D, YYYY", or "" if missing
  #   or unparseable
  def date_str
    raw = @episode["published_at"]
    return "" unless raw
    Date.parse(raw.to_s).strftime("%b %-d, %Y")
  rescue ArgumentError, TypeError
    ""
  end

  # @return [String] human duration like "42 min", or "" if unknown
  def duration_str
    seconds = @episode["duration"].to_i
    return "" if seconds <= 0
    minutes = (seconds / 60.0).round
    "#{minutes} min"
  end

  # @return [String] the description with HTML stripped, truncated to ~180 chars
  def excerpt
    raw = @episode["description"].to_s
    text = raw.gsub(/<[^>]+>/, " ").gsub("&nbsp;", " ").gsub(/\s+/, " ").strip
    (text.length > 180) ? "#{text[0, 177]}…" : text
  end
end

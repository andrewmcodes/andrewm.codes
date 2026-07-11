# Row card for the latest podcast episode data.
class EpisodeCard < Base
  ROW_CLASSES = "grid grid-cols-[96px_1fr] gap-5 py-5 border-b border-sage-4 max-sm:grid-cols-1 max-sm:gap-2 max-sm:py-4"

  # @param episode [Hash] normalized episode data from `remote_ruby.json`
  def initialize(episode:)
    @episode = episode
    super()
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

  # @return [String] the show/episode-number line, lowercased
  def show_label
    episode_number ? "remote ruby · ep #{episode_number}" : "remote ruby"
  end

  # 96px standard, matching PostRow/MetaRow (was 120px).
  def row_classes
    ROW_CLASSES
  end

  # @return [String] classes for the mono "listen" resource link.
  def resource_link_classes
    cx(
      "inline-flex items-center gap-1 pb-px border-b border-sage-5 transition-colors hover:text-mint-11 hover:border-mint-11",
      FONT_FAMILY[:mono],
      TEXT_SIZES[:xs],
      TEXT_SCHEME[:muted]
    )
  end
end

require "time"
require "uri"

# Renders the response apparatus that sits under a post: where the post was
# syndicated, the webmentions it collected (a like/repost/reply tally plus the
# reply thread), and a form to send one back.
#
# Mention data comes from `site.data.webmentions` — a webmention.io JF2 feed
# refreshed by .github/workflows/webmentions.yml (see scripts/fetch-webmentions.mjs).
# Syndication targets come from the post's own `syndication:` front matter; the
# RSS feed is always appended as the last target.
class Webmentions < Bridgetown::Component
  # JF2 `wm-property` values, grouped so each maps to one line of the tally.
  LIKES = %w[like-of].freeze
  REPOSTS = %w[repost-of].freeze
  BOOKMARKS = %w[bookmark-of].freeze
  REPLIES = %w[in-reply-to mention-of].freeze

  # Host → short label for the syndication row. An unknown host falls back to
  # itself, minus a leading "www.".
  SYNDICATION_LABELS = {
    "bsky.app" => "bluesky",
    "github.com" => "github",
    "x.com" => "x",
    "twitter.com" => "twitter",
    "dev.to" => "dev.to",
    "linkedin.com" => "linkedin",
    "www.linkedin.com" => "linkedin",
    "news.ycombinator.com" => "hn",
    "lobste.rs" => "lobsters",
    "mastodon.social" => "mastodon"
  }.freeze

  # @param url [String] the post's relative URL (e.g. "/p/slug/")
  # @param syndication [Array<String>, nil] POSSE target URLs from front matter
  def initialize(url:, syndication: nil)
    @url = url
    @syndication = Array(syndication)
    @site = Bridgetown::Current.site
  end

  private

  attr_reader :url

  # @return [String] the absolute URL webmention targets are matched against
  def target
    "#{@site.metadata.url}#{url}"
  end

  # The syndication row: front-matter targets first, RSS always last.
  # @return [Array<Hash>] `{href:, label:}` entries
  def syndication_links
    @syndication_links ||= begin
      links = @syndication.compact.map(&:to_s).reject(&:empty?).map do |href|
        {href: href, label: syndication_label(href)}
      end
      links << {href: "#{@site.metadata.url}/feed.xml", label: "rss"}
    end
  end

  # @param href [String] a syndication URL
  # @return [String] its short label
  def syndication_label(href)
    host = URI.parse(href).host.to_s.downcase
    SYNDICATION_LABELS[host] || host.sub(/\Awww\./, "")
  rescue URI::InvalidURIError
    "link"
  end

  # @return [Array<Hash>] feed entries whose wm-target is this post
  def mentions
    @mentions ||= begin
      children = @site.data.webmentions&.children
      Array(children).select { |wm| wm["wm-target"] == target }
    end
  end

  # @return [Integer] how many mentions carry one of the given properties
  def count_of(props)
    mentions.count { |wm| props.include?(wm["wm-property"]) }
  end

  def likes
    count_of(LIKES)
  end

  def reposts
    count_of(REPOSTS)
  end

  def bookmarks
    count_of(BOOKMARKS)
  end

  # @return [Array<Hash>] reply/mention entries, oldest first (a thread reads
  #   top to bottom)
  def replies
    @replies ||= mentions
      .select { |wm| REPLIES.include?(wm["wm-property"]) }
      .sort_by { |wm| wm["published"] || wm["wm-received"] || "" }
  end

  def any_mentions?
    mentions.any?
  end

  # Header tally, e.g. ["14 likes", "6 reposts", "3 replies"] — zero counts
  # drop out so the summary never reads "0 reposts".
  # @return [Array<String>]
  def summary_segments
    segs = []
    segs << pluralize(likes, "like") if likes.positive?
    segs << pluralize(reposts, "repost") if reposts.positive?
    segs << pluralize(bookmarks, "bookmark") if bookmarks.positive?
    segs << pluralize(replies.length, "reply", "replies") if replies.any?
    segs
  end

  def pluralize(count, singular, plural = nil)
    word = (count == 1) ? singular : (plural || "#{singular}s")
    "#{count} #{word}"
  end

  # @param wm [Hash] a feed entry
  # @return [Hash] its author card ({} when absent)
  def author_of(wm)
    wm["author"] || {}
  end

  # The identity shown on a reply: the author's name, else the host of their
  # URL, else a neutral fallback.
  # @param wm [Hash] a feed entry
  # @return [String]
  def handle_of(wm)
    name = author_of(wm)["name"].to_s.strip
    return name unless name.empty?
    host_of(author_of(wm)["url"] || wm["url"]) || "Someone"
  end

  def host_of(u)
    return nil if u.to_s.empty?
    URI.parse(u).host&.sub(/\Awww\./, "")
  rescue URI::InvalidURIError
    nil
  end

  # Up-to-two-letter monogram for the avatar fallback, drawn from the first two
  # "words" of the identity (or its first two letters when it is one word).
  # @param label [String] the identity from {#handle_of}
  # @return [String]
  def initials(label)
    clean = label.to_s.sub(/\A@/, "").strip
    words = clean.split(%r{[\s._\-/]+}).reject(&:empty?)
    chars =
      if words.length >= 2
        words.first(2).filter_map { |w| w[0] }
      else
        clean.gsub(/[^a-z0-9]/i, "")[0, 2].to_s.chars
      end
    result = chars.join.upcase
    result.empty? ? "•" : result
  end

  # @param wm [Hash] a feed entry
  # @return [String, nil] an ISO date, or nil if unparseable
  def published_on(wm)
    raw = wm["published"] || wm["wm-received"]
    return nil unless raw
    Time.parse(raw.to_s).strftime("%Y-%m-%d")
  rescue ArgumentError
    nil
  end

  # Use the plain-text content (never the HTML) so we never inject untrusted
  # markup from a third-party source into the page.
  # @param wm [Hash] a feed entry
  # @return [String, nil] the reply text, truncated to ~280 chars
  def content_text(wm)
    text = wm.dig("content", "text")
    return nil if text.nil? || text.strip.empty?
    (text.length > 280) ? "#{text[0, 279].rstrip}…" : text
  end
end

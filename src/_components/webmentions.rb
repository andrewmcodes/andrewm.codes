require "time"

# Renders webmention reactions (likes/reposts) and replies for a post.
#
# Data comes from `site.data.webmentions` — a webmention.io JF2 feed refreshed
# by .github/workflows/webmentions.yml (see scripts/fetch-webmentions.mjs). The
# section renders nothing when a post has no mentions.
class Webmentions < Base
  # JF2 `wm-property` values grouped into faces vs threaded responses.
  REACTIONS = %w[like-of repost-of bookmark-of].freeze
  REPLIES = %w[in-reply-to mention-of].freeze
  COMPONENT_OPTIONS = %i[url].freeze

  private

  # @return [String] the post's relative URL (e.g. "/p/slug/")
  def url
    opts[:url]
  end

  # @return [String] the absolute URL webmention targets are matched against
  def target
    "#{@site.metadata.url}#{url}"
  end

  # @return [Array<Hash>] feed entries whose wm-target is this post
  def mentions
    @mentions ||= begin
      children = @site.data.webmentions&.children
      Array(children).select { |wm| wm["wm-target"] == target }
    end
  end

  # @return [Array<Hash>] like/repost/bookmark entries (rendered as faces)
  def reactions
    @reactions ||= mentions.select { |wm| REACTIONS.include?(wm["wm-property"]) }
  end

  # @return [Array<Hash>] reply/mention entries (rendered as a thread)
  def replies
    @replies ||= mentions.select { |wm| REPLIES.include?(wm["wm-property"]) }
  end

  # @param wm [Hash] a feed entry
  # @return [Hash] its author card ({} when absent)
  def author_of(wm)
    wm["author"] || {}
  end

  # @param wm [Hash] a feed entry
  # @return [String, nil] a "Mon DD, YYYY" date, or nil if unparseable
  def published_on(wm)
    raw = wm["published"] || wm["wm-received"]
    return nil unless raw
    Time.parse(raw.to_s).strftime("%b %d, %Y")
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

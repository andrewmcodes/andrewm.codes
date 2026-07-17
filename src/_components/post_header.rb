# Post detail header with title, publish date, reading time, and tag links.
#
# Also carries the microformats2 h-entry properties (p-name, dt-published,
# p-author h-card, u-url) that webmention.io/Bridgy senders parse.
class PostHeader < Base
  COMPONENT_OPTIONS = %i[resource].freeze

  # One-off editorial clamp size for the post H1, mirroring HomeHero's
  # component-owned constant pattern (kept out of `HEADING_SIZES`' discrete
  # scale). Weight is light per the approved "thin/display-weight H1s"
  # hierarchy.
  def h1_class
    cx(
      "text-[clamp(32px,5vw,52px)] leading-[1.08] tracking-tight",
      TEXT_WEIGHT[:light],
      "text-balance text-sage-12 m-0 mb-4"
    )
  end

  private

  def resource
    opts[:resource]
  end

  def title
    resource.data.title
  end

  def date
    resource.date
  end

  def reading_time
    resource.reading_time
  end

  # CFPs are archival, event-tied proposals — their tags aren't browsable
  # topics, so suppress them in the header.
  def tags
    return [] if resource.data.kind == "cfp"
    Array(resource.data.tags)
  end

  def author_name
    @site.metadata.author.name
  end
end

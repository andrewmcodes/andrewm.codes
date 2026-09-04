# The homepage's first object: avatar, name, one claim, the ways to reach him,
# and a single derived line of evidence.
#
# The old hero argued in three paragraphs beside a four-row ledger. This one
# makes the claim once and lets the lists under it be the argument — but it
# keeps the counts, because a stranger deciding in forty seconds needs to see
# that there is a decade of work here, and a list of five titles does not say
# that on its own. Every number is derived from the collections at build time.
class HomeHero < Bridgetown::Component
  # Remote Ruby's back catalogue. Not derivable from `remote_ruby.json`, which
  # only carries the latest episode, so it is stated conservatively and stays
  # true as the show grows.
  EPISODE_COUNT = "350+"

  SOCIALS = [
    {name: "GitHub", icon: "github", url: "https://github.com/andrewmcodes"},
    {name: "Bluesky", icon: "bluesky", url: "https://bsky.app/profile/andrewm.codes"},
    {name: "X", icon: "twitter", url: "https://x.com/andrewmcodes"},
    {name: "LinkedIn", icon: "linkedin", url: "https://www.linkedin.com/in/andrew-mason"},
    {name: "RSS", icon: "rss", url: "/feed.xml"}
  ].freeze

  # @param posts_count [Integer] published posts
  # @param projects_count [Integer] open source projects
  # @param talks_count [Integer] conference talks
  def initialize(posts_count:, projects_count:, talks_count:)
    @posts_count = posts_count
    @projects_count = projects_count
    @talks_count = talks_count
  end

  def socials = SOCIALS

  # One line, four facts, no adjectives. A count that can go stale silently is
  # worse than no count, so all three of these come from the resources.
  def ledger
    [
      pluralize(@posts_count, "post"),
      pluralize(@projects_count, "project"),
      pluralize(@talks_count, "talk"),
      "#{EPISODE_COUNT} podcast episodes"
    ]
  end

  private

  def pluralize(count, noun)
    "#{count} #{noun}#{"s" unless count == 1}"
  end
end

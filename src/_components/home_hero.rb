# Homepage introduction block with the primary site message and call to action.
#
# Kept as a component so the homepage owns content choice while the design
# system owns the visual treatment.
#
# The index rows are the hero's evidence: real counts derived from the
# collections at build time, set as a ledger so accumulation is visible in the
# first viewport rather than claimed in prose.
class HomeHero < Bridgetown::Component
  # Remote Ruby's back catalogue. Not derivable from `remote_ruby.json`, which
  # only carries the latest episode, so it is stated conservatively and stays
  # true as the show grows.
  EPISODE_COUNT = "350+"

  # @param posts_count [Integer] published posts
  # @param projects_count [Integer] open source projects
  # @param talks_count [Integer] conference talks
  def initialize(posts_count:, projects_count:, talks_count:)
    @posts_count = posts_count
    @projects_count = projects_count
    @talks_count = talks_count
  end

  # @return [Array<Hash>] label / value / href rows for the hero index
  def index_rows
    [
      {label: "writing", value: pluralize(@posts_count, "post"), href: "/posts/"},
      {label: "open source", value: pluralize(@projects_count, "repo"), href: "/projects/"},
      {label: "podcast", value: "#{EPISODE_COUNT} episodes", href: "/speaking/"},
      {label: "speaking", value: pluralize(@talks_count, "talk"), href: "/speaking/"}
    ]
  end

  private

  def pluralize(count, noun)
    "#{count} #{noun}#{"s" unless count == 1}"
  end
end

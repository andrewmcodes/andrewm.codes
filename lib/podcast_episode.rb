require_relative "base"

class PodcastEpisode < Base
end

c = PodcastEpisode.new("podcast-episodes")
c.dump(c.all.to_s)

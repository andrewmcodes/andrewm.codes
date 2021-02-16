require_relative "base"

class Podcast < Base
end

c = Podcast.new("podcasts")
c.dump(c.all.to_s)

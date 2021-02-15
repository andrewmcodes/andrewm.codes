require_relative "base"

class Link < Base
end

c = Link.new("links")
c.dump(c.all.to_s)

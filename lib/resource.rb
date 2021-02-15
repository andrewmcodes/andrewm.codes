require_relative "base"

class Resource < Base
end

c = Resource.new("resources")
c.dump(c.all.to_s)

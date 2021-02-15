require_relative "base"

class Repository < Base
end

c = Repository.new("repositories")
c.dump(c.all.to_s)

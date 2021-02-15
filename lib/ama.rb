require_relative "base"

class AMA < Base
end

c = AMA.new("amas")
c.dump(c.all.to_s)

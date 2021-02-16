require_relative "base"

class Accout < Base
end

c = Accout.new("accounts")
c.dump(c.all.to_s)

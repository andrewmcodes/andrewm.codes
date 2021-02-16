require_relative "base"

class Project < Base
end

c = Project.new("projects")
c.dump(c.all.to_s)

require_relative "base"

class Article < Base
end

c = Article.new("articles")
c.dump(c.all.to_s)

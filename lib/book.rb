require_relative "base"

class Book < Base
end

c = Book.new("books")
c.dump(c.all.to_s)

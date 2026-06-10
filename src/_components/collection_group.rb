# Labeled vertical group for archive lists, such as posts grouped by year.
class CollectionGroup < Bridgetown::Component
  # @param title [String] group label rendered above the collection rows
  def initialize(title:)
    @title = title
  end
end

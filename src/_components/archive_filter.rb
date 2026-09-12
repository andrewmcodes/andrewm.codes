# Local discovery controls; the complete archive remains available without JavaScript.
class ArchiveFilter < Bridgetown::Component
  # @param kind [String] plural name of the items being filtered
  # @param count [Integer] total items, rendered before JavaScript initializes
  # @param languages [Array<String>] optional project languages
  def initialize(kind:, count:, languages: [])
    @kind = kind
    @count = count
    @languages = languages
  end
end

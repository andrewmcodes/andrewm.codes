# Compact backlink used at the top of post and archive detail pages.
class BackLink < Bridgetown::Component
  # @param href [String] destination URL
  # @param label [String] visible link label
  def initialize(href:, label:)
    @href = href
    @label = label
  end
end

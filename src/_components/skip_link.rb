# Accessibility atom for jumping directly to page content.
class SkipLink < Bridgetown::Component
  # @param href [String] destination anchor for the main content region
  # @param label [String] visible label when focused
  def initialize(href: "#main", label: "Skip to content")
    @href = href
    @label = label
  end
end

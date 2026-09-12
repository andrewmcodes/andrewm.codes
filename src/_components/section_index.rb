# A progressive-enhancement jump control built from the page's rendered headings.
class SectionIndex < Bridgetown::Component
  # @param selector [String] headings to include
  # @param label [String] accessible and visible control label
  def initialize(selector: "main section[id] h2", label: "On this page")
    @selector = selector
    @label = label
  end
end

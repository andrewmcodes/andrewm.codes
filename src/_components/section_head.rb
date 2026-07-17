# Section heading layout with optional description and trailing action link.
class SectionHead < Bridgetown::Component
  # @param title [String] section title
  # @param link_label [String, nil] optional action label
  # @param link_href [String, nil] optional action destination
  # @param description [String, nil] optional supporting copy
  # @param bordered [Boolean] whether to use the larger bordered section style
  def initialize(title:, link_label: nil, link_href: nil, description: nil, bordered: false)
    @title = title
    @link_label = link_label
    @link_href = link_href
    @description = description
    @bordered = bordered
  end

  def icon_name
    @link_href.to_s.start_with?("http") ? "arrow_top_right" : "arrow_right"
  end

  def bordered?
    @bordered || @description
  end

  def heading_classes
    cx(
      "m-0 font-mono text-xs font-medium uppercase tracking-[0.08em] text-sage-11",
      (bordered? ? "flex-1 pb-2 border-b border-sage-4" : nil)
    )
  end

  private

  def cx(*classes)
    classes.flatten.compact.join(" ")
  end
end

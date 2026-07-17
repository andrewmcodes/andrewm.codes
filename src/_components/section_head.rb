# Section heading layout with optional description and trailing action link.
class SectionHead < Base
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
    super()
  end

  def icon_name
    @link_href.to_s.start_with?("http") ? "arrow_top_right" : "arrow_right"
  end

  def bordered?
    @bordered || @description
  end

  def wrapper_classes
    bordered? ? "mb-4" : ""
  end

  def title_row_classes
    cx("flex items-baseline justify-between gap-4", bordered? ? "mb-3" : "mb-[18px]")
  end

  def heading_classes
    cx("m-0", (bordered? ? "flex-1 pb-2 border-b border-sage-4" : nil))
  end
end

# Generic dated list row for talks, CFPs, appearances, and similar metadata.
class MetaRow < Base
  ROW_CLASSES = "group items-baseline py-3.5 border-b border-sage-4 max-md:gap-1.5"

  # @param href [String] destination URL
  # @param date [String] display date
  # @param title [String] row title
  # @param meta [Array<String>] secondary metadata chips
  # @param external [Boolean] whether to open in a new tab
  # @param title_icon [Boolean] whether to render the icon beside the title
  def initialize(href:, date:, title:, meta: [], external: false, title_icon: false)
    @href = href
    @date = date
    @title = title
    @meta = Array(meta).reject { |v| v.nil? || v.to_s.strip.empty? }
    @external = external
    @title_icon = title_icon
    super()
  end

  attr_reader :href, :date, :title, :meta

  def external?
    @external
  end

  def title_icon?
    @title_icon
  end

  def icon_name
    external? ? "arrow_top_right" : "arrow_right"
  end

  # @return [String] the row's grid template + hover/border chrome, sourced
  #   from Columns' shared 96px `:list_row` template.
  def row_classes
    cx(ROW_CLASSES, Columns::TEMPLATES[:list_row], Columns::GAPS[:lg])
  end

  # @return [String, nil] extra layout classes when the title carries its own
  #   inline icon (appearances) rather than a trailing column icon.
  def title_wrap_classes
    "inline-flex items-center gap-1.5" if title_icon?
  end
end

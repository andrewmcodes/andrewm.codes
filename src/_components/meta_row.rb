# Generic dated list row for talks, CFPs, appearances, and similar metadata.
class MetaRow < Bridgetown::Component
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
end

class TimeComponent < Box
  DEFAULT_TAG = :time
  COMPONENT_OPTIONS = [:format, :prefix, :date]

  def render?
    date.present?
  end

  private

  def tag_opts
    {datetime: date_to_xmlschema(date)}
  end

  def classes
    %w[text-inherit]
  end

  def children
    return date.strftime("%Y-%m-%d") if opts[:format]&.to_sym == :clean
    return date_to_xmlschema(date) if opts[:format]&.to_sym == :iso
    date.strftime("%B %-d, %Y")
  end

  def date
    raise "[TimeComponent] Date is not present in opts" if !opts[:date] && Bridgetown.env.development?
    # TODO: We may want to validate the date here
    opts[:date] || DateTime.now
  end
end

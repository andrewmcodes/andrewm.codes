module Util
  # Time element atom with site-standard display formats.
  class Time < Box
    DEFAULT_TAG = :time
    COMPONENT_OPTIONS = %i[format prefix date].freeze

    def render?
      !date.nil?
    end

    private

    def tag_opts
      {datetime: date.iso8601}
    end

    def classes
      cx("text-inherit")
    end

    def children
      return date.strftime("%b %-d, %Y") if opts[:format]&.to_sym == :simple
      return date.strftime("%b %Y") if opts[:format]&.to_sym == :month_year
      return date.strftime("%Y-%m-%d") if opts[:format]&.to_sym == :clean
      return date.strftime("%b %d, %Y at %H:%M %Z") if opts[:format]&.to_sym == :timeline
      return date.iso8601 if opts[:format]&.to_sym == :iso

      format = (date.year == ::Time.now.year) ? "%b %-d" : "%b %-d, %Y"
      date.strftime(format)
    end

    def date
      @date ||= opts[:date]
    end
  end
end

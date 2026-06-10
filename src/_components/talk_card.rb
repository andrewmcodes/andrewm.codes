# Talk list row with event metadata, abstract, and resource links.
class TalkCard < Bridgetown::Component
  # @param talk [Hash] talk data from `src/_data/talks.yml`
  def initialize(talk:)
    @talk = talk
  end

  # @return [String] the talk date formatted "Mon D, YYYY", or "" if missing
  #   or unparseable
  def date_str
    d = @talk["date"] || @talk[:date]
    return "" unless d
    parsed = d.is_a?(String) ? Date.parse(d) : d
    parsed.strftime("%b %-d, %Y")
  rescue ArgumentError, TypeError
    ""
  end

  # Reads a talk field by either string or symbol key.
  # @param key [String, Symbol] the field name
  # @return [Object, nil] the value, or nil if absent
  def field(key)
    @talk[key.to_s] || @talk[key.to_sym]
  end
end

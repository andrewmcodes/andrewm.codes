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

  # Where it was given is a fact about the talk, so it sits with the other
  # facts rather than as an accent line above the title.
  # @return [Array<String>] venue, and the city when it is recorded
  def venue_facts
    [field(:venue), field(:city)].compact
  end

  # @return [Array<Hash>] normalized `{label:, href:, external:}` resources
  def links
    Array(field(:links)).map do |l|
      {
        label: l["label"] || l[:label],
        href: l["href"] || l[:href],
        external: true
      }
    end
  end
end

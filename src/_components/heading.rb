# Heading atom for tokenized heading size, weight, and color.
class Heading < Box
  COMPONENT_OPTIONS = %i[size weight scheme].freeze
  DEFAULT_TAG = :h2

  private

  def classes
    cx(
      HEADING_SIZES.fetch(opts[:size], HEADING_SIZES[:md]),
      TEXT_WEIGHT.fetch(opts[:weight], TEXT_WEIGHT[:semibold]),
      HEADING_SCHEME.fetch(opts[:scheme], HEADING_SCHEME[:default]),
      "break-words tracking-tight"
    )
  end

  def tag_opts
    {id: opts[:id] || slugify(content.to_s)}
  end
end

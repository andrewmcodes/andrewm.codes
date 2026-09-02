# Heading atom for tokenized heading size, weight, and color.
class Heading < Box
  COMPONENT_OPTIONS = %i[size weight scheme].freeze
  DEFAULT_TAG = :h2

  private

  def classes
    # Weight and tracking ride on the size role, so neither is applied here
    # unless a caller explicitly overrides the weight.
    cx(
      HEADING_SIZES.fetch(opts[:size], HEADING_SIZES[:md]),
      TEXT_WEIGHT[opts[:weight]],
      HEADING_SCHEME.fetch(opts[:scheme], HEADING_SCHEME[:default]),
      "break-words"
    )
  end

  def tag_opts
    {id: opts[:id] || slugify(content.to_s)}
  end
end

# Heading atom for tokenized heading size, weight, and color.
#
# @option opts [Symbol] :size one of `Base::HEADING_SIZES`
# @option opts [Symbol] :weight one of `Base::TEXT_WEIGHT`
# @option opts [Symbol] :scheme one of `Base::HEADING_SCHEME`
# @option opts [Symbol] :leading token from `Base::LEADING`
class Heading < Box
  COMPONENT_OPTIONS = %i[size weight scheme leading].freeze
  DEFAULT_TAG = :h2

  private

  def classes
    cx(
      HEADING_SIZES.fetch(opts[:size], HEADING_SIZES[:md]),
      TEXT_WEIGHT.fetch(opts[:weight], TEXT_WEIGHT[:semibold]),
      HEADING_SCHEME.fetch(opts[:scheme], HEADING_SCHEME[:default]),
      (LEADING[opts[:leading]&.to_sym] if opts[:leading] && LEADING.key?(opts[:leading]&.to_sym)),
      "break-words tracking-tight"
    )
  end

  def tag_opts
    {id: opts[:id] || slugify(content.to_s)}
  end
end

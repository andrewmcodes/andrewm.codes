# Heading atom. Owns size and tone; the type role carries weight and tracking,
# so neither is applied here unless a caller explicitly overrides the weight.
#
# Like `Text`, it sets no margin. A heading's distance from the thing it heads
# is the surrounding `Stack`'s decision.
class Heading < Box
  COMPONENT_OPTIONS = %i[size weight tone balance].freeze
  DEFAULT_TAG = :h2

  private

  def classes
    cx(
      "m-0 break-words",
      token(HEADING_SIZES, opts[:size], :page),
      (TEXT_WEIGHT[opts[:weight]&.to_sym] if opts[:weight]),
      token(TONE, opts[:tone], :neutral),
      ("text-balance" if opts[:balance])
    )
  end

  def tag_opts
    {id: opts[:id] || slugify(content.to_s)}
  end
end

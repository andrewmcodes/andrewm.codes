# Text atom. Owns size, tone, weight, and family — and nothing else.
#
# It sets no margin by design. Vertical space between a paragraph and whatever
# follows it belongs to the `Stack` around them, so the same `Text` can be
# dropped into a hero, a list row, or a footer without carrying a rhythm
# decision from one into the next.
#
# @option opts [Symbol] :size type role from `Base::TEXT_SIZES`
# @option opts [Symbol] :tone semantic tone from `Base::TONE`
# @option opts [Symbol] :weight override from `Base::TEXT_WEIGHT`
# @option opts [Symbol] :font (`:sans`) one of `Base::FONT_FAMILY`
class Text < Box
  COMPONENT_OPTIONS = %i[size tone weight font truncate balance].freeze
  DEFAULT_TAG = :p

  private

  def classes
    cx(
      "m-0",
      token(TEXT_SIZES, opts[:size], :none),
      (token(TONE, opts[:tone], :inherit) if opts[:tone]),
      (TEXT_WEIGHT[opts[:weight]&.to_sym] if opts[:weight]),
      (FONT_FAMILY[opts[:font]&.to_sym] if opts[:font]),
      ("truncate" if opts[:truncate]),
      ("text-pretty" if opts[:balance])
    )
  end
end

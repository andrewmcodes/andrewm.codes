# Text atom for tokenized paragraph and inline copy styles.
#
# @option opts [Symbol] :variant (`:default`) one of `VARIANTS`
# @option opts [Symbol] :size token from `Base::TEXT_SIZES`
# @option opts [Symbol] :scheme token from `Base::TEXT_SCHEME`
class Text < Box
  COMPONENT_OPTIONS = %i[size weight scheme font truncate variant].freeze
  DEFAULT_TAG = :p

  VARIANTS = {
    default: "",
    source_note: "mt-10 text-[12.5px] text-sage-10"
  }.freeze

  private

  def classes
    c = []
    c << VARIANTS.fetch(opts.fetch(:variant, :default), VARIANTS[:default])
    c << TEXT_SIZES.fetch(opts[:size]&.to_sym, TEXT_SIZES[:none])
    c << TEXT_WEIGHT[opts[:weight]&.to_sym] if opts[:weight] && TEXT_WEIGHT.key?(opts[:weight]&.to_sym)
    c << TEXT_SCHEME[opts[:scheme]&.to_sym] if opts[:scheme] && TEXT_SCHEME.key?(opts[:scheme]&.to_sym)
    c << FONT_FAMILY[opts[:font]&.to_sym] if opts[:font] && FONT_FAMILY.key?(opts[:font]&.to_sym)
    c << "truncate" if opts[:truncate]
    c
  end
end

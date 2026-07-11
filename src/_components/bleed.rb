# Full-bleed breakout for wide content (tables, media, code) that needs to
# escape the narrow prose column at larger breakpoints.
#
# Applies negative horizontal margins so content can extend past its parent's
# padding without the parent itself giving up its max-width constraint.
#
# @option opts [Symbol] :amount (`:md`) one of `AMOUNTS`
class Bleed < Box
  COMPONENT_OPTIONS = %i[amount].freeze

  AMOUNTS = {
    sm: "md:-mx-4",
    md: "md:-mx-8",
    lg: "md:-mx-12"
  }.freeze

  private

  def classes
    cx(AMOUNTS.fetch(opts.fetch(:amount, :md), AMOUNTS[:md]))
  end
end

class Card < Box
  COMPONENT_OPTIONS = [:variant, :spacing]

  CARD_STYLES = {
    default: "",
    outlined: "border border-radix-slate7 rounded-xl",
    elevated: "shadow-md bg-radix-slate2 rounded-xl border slate-border",
    filled: "shadow-md bg-radix-slate3 rounded-xl",
    filled_link: "shadow-md slate-bg-int rounded-xl"
  }
  CARD_SPACING = {
    none: "",
    default: "px-4 sm:px-6 py-6",
    tile: "px-4 sm:px-6 py-4"
  }

  private

  def classes
    c = %w[group relative flex flex-col items-start]
    c << CARD_STYLES.fetch(opts[:variant], CARD_STYLES[:default])
    c << CARD_SPACING.fetch(opts[:spacing], CARD_SPACING[:default])
    c
  end
end

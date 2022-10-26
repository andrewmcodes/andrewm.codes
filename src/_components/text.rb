class Text < Box
  COMPONENT_OPTIONS = [:size, :variant, :leading, :weight, :font]
  DEFAULT_TAG = :p
  TEXT_SIZES = {
    default: "text-base",
    xs: "text-xs",
    sm: "text-sm",
    lg: "text-lg"
  }
  TEXT_COLORS = {
    default: "text-radix-slate11",
    strong: "text-radix-slate12",
    primary: "text-radix-blue11",
    warning: "text-radix-red11",
  }
  TEXT_LEADING = {
    default: "",
    loose: "leading-loose"
  }
  FONT_STYLES = {
    default: "",
    sans: "font-sans",
    mono: "font-mono"
  }

  private

  def classes
    c = %w[]
    c << TEXT_SIZES.fetch(opts[:size], TEXT_SIZES[:default])
    c << TEXT_COLORS.fetch(opts[:color], TEXT_COLORS[:default])
    c << TEXT_LEADING.fetch(opts[:leading], TEXT_LEADING[:default])
    c << TEXT_WEIGHT.fetch(opts[:weight], TEXT_WEIGHT[:default])
    c << FONT_STYLES.fetch(opts[:font], FONT_STYLES[:default])
    c
  end
end

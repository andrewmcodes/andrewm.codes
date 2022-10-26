class Heading < Box
  COMPONENT_OPTIONS = [:size, :variant, :weight, :tracking, :color]
  DEFAULT_TAG = :h1

  FONT_WEIGHTS = {
    semibold: "font-semibold",
    extrabold: "font-extrabold",
    medium: "font-medium",
    bold: "font-bold"
  }

  TEXT_COLORS = {
    default: "text-radix-slate12",
    muted: "text-radix-slate11",
    primary: "text-radix-blue11",
    secondary: "text-radix-cyan11",
    tertiary: "text-radix-violet11",
    warning: "text-radix-amber11",
    error: "text-radix-red11"
  }

  TEXT_SIZES = {
    default: "text-4xl lg:text-5xl",
    sm: "text-sm",
    base: "text-base",
    lg: "text-lg",
    headline: "text-3xl sm:text-4xl lg:text-5xl"
  }

  TEXT_TRACKING = {
    default: "",
    tight: "tracking-tight"
  }

  TEXT_VARIANTS = {
    title_sm: "#{TEXT_SIZES[:base]} #{FONT_WEIGHTS[:semibold]} #{TEXT_COLORS[:default]} #{TEXT_TRACKING[:tight]}",
    title: "#{TEXT_SIZES[:base]} #{FONT_WEIGHTS[:bold]} #{TEXT_COLORS[:default]}",
    section_sm: "#{TEXT_SIZES[:sm]} #{FONT_WEIGHTS[:semibold]} #{TEXT_COLORS[:muted]}",
    section: "#{TEXT_SIZES[:lg]} #{FONT_WEIGHTS[:semibold]} #{TEXT_COLORS[:muted]}",
    headline: "#{TEXT_SIZES[:headline]} #{FONT_WEIGHTS[:extrabold]} #{TEXT_COLORS[:default]} #{TEXT_TRACKING[:tight]}",
    display: "#{TEXT_SIZES[:headline]} #{FONT_WEIGHTS[:extrabold]}",
    lg: "#{TEXT_SIZES[:default]} #{FONT_WEIGHTS[:semibold]}",
    md: "#{TEXT_SIZES[:base]} #{FONT_WEIGHTS[:semibold]}",
    sm: "#{TEXT_SIZES[:sm]} #{FONT_WEIGHTS[:semibold]}"
  }

  private

  def classes
    c = %w[]
    if opts[:variant]
      c << TEXT_VARIANTS.fetch(opts[:variant], "")
    else
      c << TEXT_SIZES.fetch(opts[:size], TEXT_SIZES[:default])
      c << FONT_WEIGHTS.fetch(opts[:weight], FONT_WEIGHTS[:semibold])
      c << TEXT_TRACKING.fetch(opts[:tracking], TEXT_TRACKING[:default]) # , TEXT_TRACKING[:tight]
    end
    c << TEXT_COLORS.fetch(opts[:color], TEXT_COLORS[:default])
    c
  end
end

class Title < Box
  COMPONENT_OPTIONS = [:size, :variant, :sr]
  DEFAULT_TAG = :h3

  SIZE = {
    default: "text-base font-semibold",
    xs: "text-xs font-medium",
    sm: "text-sm font-medium",
    lg: "text-4xl font-semibold",
    display: "text-3xl sm:text-4xl lg:text-5xl font-extrabold"
  }

  VARIANT = {
    none: "",
    default: "text-radix-slate12",
    strong: "text-radix-slate12",
    muted: "text-radix-slate11"
  }

  private

  def classes
    c = %w[]
    c << SIZE.fetch(opts[:size], SIZE[:default])
    c << VARIANT.fetch(opts[:variant], VARIANT[:default])
    c << "sr-only" if opts[:sr] == true
    c
  end
end

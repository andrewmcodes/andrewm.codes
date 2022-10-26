class Prose < Box
  COMPONENT_OPTIONS = [:size, :variant]
  PROSE_SIZES = {
    default: "prose-base",
    sm: "prose-sm",
    lg: "prose-lg"
  }
  PROSE_VARIANTS = {
    default: "prose dark:prose-invert",
    warning: "prose prose-warning dark:prose-warning"
  }

  private

  def classes
    c = %w[]
    c << PROSE_VARIANTS.fetch(opts[:variant], PROSE_VARIANTS[:default])
    c << PROSE_SIZES[opts[:size]&.to_sym || :default]
    c
  end
end

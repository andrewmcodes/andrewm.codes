class Card::Cta < Box
  COMPONENT_OPTIONS = [:icon, :mt]
  MARGIN_TOP_OPTIONS = {
    default: "mt-4",
    none: "mt-0"
  }

  def call
    render Box.new(**helper_opts) do
      [
        content,
        render(Icon.new(name: icon))
      ].join.html_safe
    end
  end

  private

  def icon
    opts[:icon] || "chevron_right"
  end

  def classes
    c = %w[relative z-10 flex items-center text-sm font-medium text-radix-blue11]
    c << MARGIN_TOP_OPTIONS.fetch(opts[:mt], MARGIN_TOP_OPTIONS[:default])
    c
  end

  def tag_opts
    {"aria-hidden": true}
  end
end

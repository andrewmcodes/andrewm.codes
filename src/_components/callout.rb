class Callout < Base
  COMPONENT_OPTIONS = [:variant, :title]
  VARIANT_STYLES = {
    info: "blue-bg text-radix-blue11 blue-border",
    warning: "amber-bg text-radix-amber11 amber-border",
    error: "red-bg text-radix-red11 red-border",
    default: "cyan-bg text-radix-cyan11 cyan-border"
  }
  VARIANT_ICON = {
    info: "info",
    warning: "warning",
    error: "error",
    default: "check"
  }
  VARIANT_TEXT = {
    info: "Info",
    warning: "Warning",
    error: "Error",
    default: "Note"
  }

  private

  def tag_opts
    {as: :aside}
  end

  def classes
    c = %w[p-4 my-8 rounded-xl border flex]
    c << VARIANT_STYLES[opts[:variant]&.to_sym || :default]
    c
  end

  def title
    return opts[:title] if opts[:title]

    VARIANT_TEXT[opts[:variant]&.to_sym || :default]
  end

  def icon
    VARIANT_ICON[opts[:variant]&.to_sym || :default]
  end
end

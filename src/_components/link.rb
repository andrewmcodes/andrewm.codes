class Link < Base
  COMPONENT_OPTIONS = [:variant]
  DEFAULT_TAG = :a
  VARIANT_STYLES = {
    default: "",
    primary: "text-radix-blue11",
    muted: "text-radix-slate11 hover:text-radix-blue11 text-sm font-medium",
    strong: "text-radix-slate12 hover:text-radix-blue11 text-sm font-medium transition"
  }

  renders_one :leading_icon, ->(**leading_opts) do
    Icon.new(**leading_opts)
  end

  renders_one :trailing_icon, ->(**trailing_opts) do
    Icon.new(**trailing_opts)
  end

  private

  def classes
    c = %w[]
    c << VARIANT_STYLES[opts[:variant]&.to_sym || :default]
    c
  end

  def tag_name
    opts[:href] ? "a" : "button"
  end
end

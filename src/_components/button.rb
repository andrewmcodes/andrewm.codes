class Button < Base
  COMPONENT_OPTIONS = [:variant, :text, :size]
  VARIANT_STYLES = {
    default: "slate-cta text-radix-slate12 active:bg-radix-slate5 shadow-sm",
    text: "text-radix-slate11 hover:bg-radix-slate4 active:bg-radix-slate5",
    primary_outline: "bg-radix-blue1 text-radix-blue11 blue-border-int border"
  }
  SIZE_STYLES = {
    default: "py-2 px-3",
    sm: "py-0.5 px-2",
    xs: "py-0 px-2"
  }

  renders_one :text
  renders_one :leading_icon, ->(**leading_opts) do
    Icon.new(**leading_opts)
  end

  renders_one :trailing_icon, ->(**trailing_opts) do
    Icon.new(**trailing_opts)
  end

  private

  def classes
    c = %w[inline-flex items-center font-medium gap-2 justify-center rounded-lg text-sm [&>span]:font-medium outline-offset-2]
    c << VARIANT_STYLES[opts[:variant]&.to_sym || :default]
    c << SIZE_STYLES[opts[:size]&.to_sym || :default]
    c
  end

  def tag_name
    opts[:href] ? "a" : "button"
  end
end

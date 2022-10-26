class Dropdown < Base
  COMPONENT_OPTIONS = [:position]

  POSITION_STYLES = {
    right: "right-0",
    left: "left-0"
  }

  renders_one :trailing_icon, ->(**trailing_opts) do
    Icon.new(**trailing_opts)
  end

  renders_many :items, ->(title:, href:) do
    Link.new(href: href, class_name: item_classes).with_content(title)
  end

  private

  def classes
    c = %w[absolute mt-1 w-40 bg-radix-slate3 rounded-md shadow-md]
    c << POSITION_STYLES[opts[:position]&.to_sym || :left]
    c
  end

  def item_classes
    "block w-full first-of-type:rounded-t-md last-of-type:rounded-b-md px-4 py-2.5 text-left text-sm text-radix-slate12 font-medium hover:bg-radix-slate4 active:bg-radix-slate5 disabled:text-radix-slate11"
  end
end

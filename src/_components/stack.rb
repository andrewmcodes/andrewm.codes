class Stack < Box
  COMPONENT_OPTIONS = [:direction, :items, :justify, :y, :x, :gap]
  FLEX_ITEM_OPTIONS = {
    default: "",
    center: "items-center"
  }
  JUSTIFY_CONTENT_OPTIONS = {
    default: "",
    between: "justify-between",
    end: "justify-end"
  }
  SPACE_Y_OPTIONS = {
    default: "",
    xs: "space-y-2",
    sm: "space-y-4",
    md: "space-y-6",
    lg: "space-y-12",
    xl: "space-y-16",
    xxl: "space-y-20"
  }

  SPACE_X_OPTIONS = {
    default: "",
    sm: "space-x-2",
    md: "space-x-4"
  }
  GAP_OPTIONS = {
    default: "",
    sm: "gap-2",
    md: "gap-4"
  }

  private

  def classes
    c = %w[flex]
    c << "flex-col" unless opts[:direction] == :row
    c << FLEX_ITEM_OPTIONS.fetch(opts[:items], FLEX_ITEM_OPTIONS[:default])
    c << JUSTIFY_CONTENT_OPTIONS.fetch(opts[:justify], JUSTIFY_CONTENT_OPTIONS[:default])
    c << SPACE_Y_OPTIONS.fetch(opts[:y], SPACE_Y_OPTIONS[:default])
    c << SPACE_X_OPTIONS.fetch(opts[:x], SPACE_X_OPTIONS[:default])
    c << GAP_OPTIONS.fetch(opts[:gap], GAP_OPTIONS[:default])
    c
  end
end

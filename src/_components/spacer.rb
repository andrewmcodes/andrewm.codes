class Spacer < Box
  COMPONENT_OPTIONS = [:y]

  SPACE_Y = {
    xs: "space-y-2",
    sm: "space-y-4",
    md: "space-y-6",
    lg: "space-y-12",
    xl: "space-y-16",
    xxl: "space-y-20"
  }

  private

  def classes
    c = %w[]
    c << SPACE_Y.fetch(opts[:y], "")
    c
  end
end

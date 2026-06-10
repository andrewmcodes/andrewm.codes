# SVG icon atom backed by files in `src/images`.
#
# Falls back to the external-link icon when a requested icon is missing.
class Icon < Base
  COMPONENT_OPTIONS = %i[name size].freeze
  ICON_PATH = "/images"

  ICON_SIZES = {
    sm: {classes: "w-4 h-4", width: 16, height: 16},
    default: {classes: "w-[0.9375rem] h-[0.9375rem]", width: 15, height: 15},
    lg: {classes: "w-6 h-6", width: 24, height: 24},
    xl: {classes: "w-12 h-12", width: 48, height: 48}
  }.freeze

  def call
    name = opts[:name] || "info"
    svg "#{ICON_PATH}/#{name}.svg", **helper_opts
  rescue Errno::ENOENT
    svg "#{ICON_PATH}/external.svg", **helper_opts
  end

  private

  def classes
    cx(
      "flex-none",
      ICON_SIZES.fetch(opts[:size], ICON_SIZES[:default])[:classes]
    )
  end

  def tag_opts
    size = ICON_SIZES.fetch(opts[:size], ICON_SIZES[:default])
    {width: size[:width], height: size[:height]}
  end
end

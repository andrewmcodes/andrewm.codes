# Figure wrapper for images/media with optional slotted captions.
class Figure < Base
  COMPONENT_OPTIONS = %i[text aspect].freeze

  private

  def aspect
    case opts[:aspect]
    when :square then "aspect-square"
    when :video then "aspect-video"
    else "aspect-auto"
    end
  end
end

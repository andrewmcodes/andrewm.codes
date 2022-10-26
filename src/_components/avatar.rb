#
# sizes={large ? '4rem' : '2.25rem'}
#
class Avatar < Base
  COMPONENT_OPTIONS = [:size]
  RING_VARIANT = {
    default: "ring-1 ring-radix-slate7 bg-radix-slate1 shadow-sm"
  }
  SIZE_CLASSES = {
    default: "w-9 h-9",
    lg: "w-18 h-18"
  }
  SIZE_DIMENSIONS = {
    default: "36",
    lg: "96"
  }

  def call
    render Link.new(href: opts[:href] || absolute_url("/"), **helper_opts) do
      render Image.new(
        src: opts[:size] == :lg ? site.metadata.author.avatar : site.metadata.author.avatar_sm,
        alt: site.metadata.author.name,
        width: SIZE_DIMENSIONS.fetch(opts[:size], SIZE_DIMENSIONS[:default]),
        height: SIZE_DIMENSIONS.fetch(opts[:size], SIZE_DIMENSIONS[:default]),
        class_name: "#{RING_VARIANT[:default]} rounded-full object-cover #{SIZE_CLASSES.fetch(opts[:size], SIZE_CLASSES[:default])}"
      )
    end
  end

  private

  def tag_opts
    {"aria-label": "Home"}
  end

  def classes
    %w[pointer-events-auto]
  end
end

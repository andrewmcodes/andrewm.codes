# Tokenized image atom with local and ImageKit source support.
class Image < Box
  DEFAULT_TAG = :img
  COMPONENT_OPTIONS = %i[iid transform variant src alt height width loading].freeze

  # `cover` and `card` are gone: both were unreachable, and `cover` carried the
  # last 12px radius on the site — a shape decision being read as shipped
  # design when no caller could render it. `figure` is currently unused too
  # (Figure takes its image as a slot), but it is the treatment a framed image
  # should get, so it stays as the answer rather than as a leftover.
  VARIANT_OPTIONS = {
    default: "",
    # A figure scrolls with the document, so it is bounded by a hairline, not
    # lifted by a shadow. Shadows belong to things that genuinely float.
    figure: "rounded-lg object-cover object-center ring-1 ring-mauve-6 mx-auto",
    avatar: "inline-block h-6 w-6 rounded-full"
  }.freeze

  def call
    attrs = html_attributes(**helper_opts, prefix_space: true)
    html -> { "<img#{attrs}>" }
  end

  private

  def tag_opts
    t = {src: csrc || opts[:src]}
    t[:height] = opts[:height] if opts[:height]
    t[:width] = opts[:width] if opts[:width]
    t[:alt] = opts[:alt] if opts[:alt]
    t[:loading] = opts.fetch(:loading, "lazy")
    t
  end

  def classes
    cx(VARIANT_OPTIONS.fetch(opts[:variant], VARIANT_OPTIONS[:default]))
  end

  def csrc
    return nil unless opts[:iid]
    transforms = (opts[:transform] == false) ? {} : opts.fetch(:transform, {})
    imagekit_url(opts[:iid], **transforms)
  end
end

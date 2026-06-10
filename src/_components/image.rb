# Tokenized image atom with local and Cloudinary source support.
class Image < Box
  DEFAULT_TAG = :img
  COMPONENT_OPTIONS = %i[cid transform variant src alt height width loading].freeze

  VARIANT_OPTIONS = {
    default: "",
    figure: "rounded-lg object-cover object-center shadow-lg ring-1 ring-slate-6 mx-auto",
    cover: "object-cover w-full rounded-t-xl",
    card: "absolute inset-0 -z-10 h-full w-full object-cover",
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
    return nil unless opts[:cid]
    transforms = (opts[:transform] == false) ? {} : opts.fetch(:transform, {})
    cloudinary_url(opts[:cid], **transforms)
  end
end

class Image < Box
  DEFAULT_TAG = :img
  COMPONENT_OPTIONS = [:cid, :transform, :variant]
  VARIANT_OPTIONS = {
    default: "",
    figure: "rounded-lg object-cover object-center shadow-lg"
  }

  private

  def tag_opts
    {src: (csrc || opts[:src])}
  end

  def classes
    c = %w[]
    c << VARIANT_OPTIONS.fetch(opts[:variant], VARIANT_OPTIONS[:default])
    c
  end

  def csrc
    return unless opts[:cid]

    transform = opts.fetch(:transform, :medium) unless transform == false

    if transform
      cloudinary_url(opts[:cid], transform)
    else
      cloudinary_url(opts[:cid])
    end
  end

  def transform
    opts[:transform]
  end
end

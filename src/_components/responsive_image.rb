class ResponsiveImage < Box
  FALLBACK_WIDTHS = [300, 600, 680, 1024]
  FALLBACK_WIDTH = 680
  DEFAULT_TAG = :img
  COMPONENT_OPTIONS = [:file, :widths, :sizes]

  private

  def tag_opts
    {
      src: get_src(opts[:file]),
      srcset: get_srcset(opts[:file]),
      sizes: opts[:sizes] || default_sizes,
      loading: opts[:loading] || "lazy",
      alt: opts[:alt] || "TODO",
      width: opts[:width] || 1024,
      height: opts[:height] || 576
    }
  end

  def get_srcset(file, widths = nil)
    width_set = widths || FALLBACK_WIDTHS
    width_set.map { |width| "#{get_src(file, width)} #{width}w" }.join(", ")
  end

  def get_src(file, width = nil)
    "https://res.cloudinary.com/#{site.config.cloudinary.cloud_name}/image/upload/q_auto,f_auto,w_#{width || FALLBACK_WIDTH}/#{file}"
  end

  def default_sizes
    "(min-width: 980px) 928px, calc(95.15vw + 15px)"
  end
end

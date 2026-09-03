class Builders::Imagekit < SiteBuilder
  # `imagekit_url("path/to/asset.png", :medium)` — preset symbol form, used
  # from posts. `imagekit_url("path/to/asset.png", w: 800)` — raw transform
  # form, used by the Image component.
  #
  # ImageKit puts transforms in a `tr=` query param with hyphenated pairs,
  # where Cloudinary used underscored path segments. Endpoint and presets live
  # in bridgetown.config.yml so the account is configuration, not a constant
  # buried in a builder.
  #
  # Presets carry width only: ImageKit already applies format and quality
  # negotiation by default, so `f-auto,q-auto` would restate the default.
  def build
    helper :imagekit_url do |path, preset = nil, **options|
      config = site.config.imagekit
      opts = preset.is_a?(Symbol) ? (config[:presets][preset] || {}) : options
      transforms = opts.map { |k, v| "#{k}-#{v}" }.join(",")
      base = "#{config[:url_endpoint].chomp("/")}/#{path.to_s.delete_prefix("/")}"
      transforms.empty? ? base : "#{base}?tr=#{transforms}"
    end
  end
end

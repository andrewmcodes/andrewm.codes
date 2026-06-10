class Builders::Cloudinary < SiteBuilder
  CLOUD_NAME = "andrewmcodes"
  BASE = "https://res.cloudinary.com/#{CLOUD_NAME}/image/upload".freeze

  PRESETS = {
    medium: {w: 800, q: "auto", f: "auto"},
    small: {w: 400, q: "auto", f: "auto"},
    large: {w: 1200, q: "auto", f: "auto"}
  }.freeze

  # `cloudinary_url("path/to/asset.png", :medium)` — preset symbol form, used
  # from posts. `cloudinary_url("path/to/asset.png", w: 800, q: "auto")` —
  # raw transform form, used by the Image component.
  def build
    helper :cloudinary_url do |path, preset = nil, **options|
      opts = preset.is_a?(Symbol) ? PRESETS.fetch(preset, {}) : options
      transforms = opts.map { |k, v| "#{k}_#{v}" }.join(",")
      transforms.empty? ? "#{BASE}/#{path}" : "#{BASE}/#{transforms}/#{path}"
    end
  end
end

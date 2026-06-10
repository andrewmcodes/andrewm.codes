# Bridgetown skips underscore-prefixed files in the source root, so `src/_headers`
# never reaches the build output on its own. Cloudflare Workers Static Assets
# consumes a `_headers` file the same way it consumes `_redirects` (which
# Builders::Redirects writes), so copy it into the destination at build time.
class Builders::Headers < SiteBuilder
  def build
    hook :site, :post_write do |site|
      next unless site.config.destination

      source = site.in_source_dir("_headers")
      next unless File.exist?(source)

      File.write(File.join(site.config.destination, "_headers"), File.read(source))
    end
  end
end

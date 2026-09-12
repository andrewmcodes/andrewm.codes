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

      headers = File.read(source).rstrip
      headers << "\n\n#{markdown_alternate_headers(site)}"
      File.write(File.join(site.config.destination, "_headers"), "#{headers.rstrip}\n")
    end
  end

  private

  def markdown_alternate_headers(site)
    lines = [
      "/",
      '  Link: </index.md>; rel="alternate"; type="text/markdown"',
      "",
      "/index.md",
      '  Link: </>; rel="alternate"; type="text/html"'
    ]

    Builders::MarkdownSource::POST_COLLECTIONS.each do |label|
      prefix = site.collections[label]&.resources&.first&.relative_url.to_s.split("/")[1]
      next if prefix.to_s.empty?

      lines.concat([
        "",
        "/#{prefix}/*/",
        "  Link: </#{prefix}/:splat.md>; rel=\"alternate\"; type=\"text/markdown\"",
        "",
        "/#{prefix}/*.md",
        "  Link: </#{prefix}/:splat/>; rel=\"alternate\"; type=\"text/html\""
      ])
    end

    markdown_pages(site).each do |resource|
      markdown_path = Builders::MarkdownSource.path_for(resource)
      lines.concat([
        "",
        resource.relative_url,
        "  Link: <#{markdown_path}>; rel=\"alternate\"; type=\"text/markdown\"",
        "",
        markdown_path,
        "  Link: <#{resource.relative_url}>; rel=\"alternate\"; type=\"text/html\""
      ])
    end

    lines.join("\n")
  end

  def markdown_pages(site)
    Builders::MarkdownSource.exported_resources(site).select do |resource|
      resource.collection&.label == "pages"
    end
  end
end

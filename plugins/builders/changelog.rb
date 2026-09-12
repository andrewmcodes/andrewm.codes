class Builders::Changelog < SiteBuilder
  def build
    hook :site, :post_read do |site|
      path = site.in_root_dir("CHANGELOG.md")
      next unless File.exist?(path)

      raw = File.read(path)
      body = raw.sub(/\A---\s*\n.*?\n---\s*\n*/m, "")
      # The page supplies its own "Changelog" title, so drop the leading H1
      # that release-please always emits to avoid a duplicate <h1>.
      body = body.sub(/\A#\s+.*\n+/, "")
      body = body.gsub(/^\#{1,6}\s+(?=\[?\d+\.\d+\.\d+)/, "## ")
      site.data["changelog"] = body.gsub(/(\]\([^\n]+?\))\s*\((\d{4}-\d{2}-\d{2})\)/, '\1 — \2')
    end
  end
end

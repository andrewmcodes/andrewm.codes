class Builders::Changelog < SiteBuilder
  def build
    hook :site, :pre_read do |site|
      path = File.join(site.root_dir, "CHANGELOG.md")
      next unless File.exist?(path)

      raw = File.read(path)
      body = raw.sub(/\A---\s*\n.*?\n---\s*\n*/m, "")
      site.data["changelog"] = body
    end
  end
end

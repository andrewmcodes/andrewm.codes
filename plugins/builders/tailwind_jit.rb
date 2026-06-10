class Builders::TailwindJit < SiteBuilder
  def build
    hook :site, :pre_reload do |_, paths|
      next if paths.length == 1 && paths.first.ends_with?("manifest.json")

      refresh_file = site.in_root_dir("frontend", "styles", "jit-refresh.css")
      File.write refresh_file, "/* #{Time.now.to_i} */"
      throw :halt
    end
  end
end

class VercelUrl < SiteBuilder
  def build
    hook :site, :pre_render do |s|
      next unless ENV["VERCEL_URL"] && ENV["VERCEL_ENV"] == "preview"
      Bridgetown.logger.info("Subbing Vercel URL")
      site.config.update(url: "https://" + ENV["VERCEL_URL"])
    end
  end
end

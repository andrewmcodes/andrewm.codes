# Site-wide footer with account links, feed links, and commit metadata.
class SiteFooter < Base
  def initialize
    @site = Bridgetown::Current.site
  end

  def metadata
    @site.metadata
  end

  def accounts
    @site.data.accounts
  end

  # @return [String] e.g. "© 2019–2026 Andrew Mason"
  def copyright_line
    "© 2019–#{Date.today.year} #{metadata.author.name}"
  end
end

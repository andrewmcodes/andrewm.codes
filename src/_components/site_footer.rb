# Site-wide footer with account links, feed links, and commit metadata.
class SiteFooter < Bridgetown::Component
  def initialize
    @site = Bridgetown::Current.site
  end

  def metadata
    @site.metadata
  end

  def accounts
    @site.data.accounts
  end
end

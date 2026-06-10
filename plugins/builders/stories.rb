require "fileutils"

# The component story pages (src/_stories → /stories/<name>/) exist only so
# Storybook can consume their rendered HTML during local development. They must
# never ship to the live site. They render in every environment (simpler than
# conditionally registering a collection), so in production we delete the
# rendered directory after write. Dev/test builds keep it for `mise run
# storybook`.
class Builders::Stories < SiteBuilder
  # Registers the production-only cleanup hook.
  # @return [void]
  def build
    return unless Bridgetown.env.production?

    hook :site, :post_write do |site|
      FileUtils.rm_rf(File.join(site.config.destination, "stories"))
    end
  end
end

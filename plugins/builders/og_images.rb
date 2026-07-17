require_relative "../og_helper"

# Wires up Open Graph images. A resources:post_read hook assigns each
# post/project/page/cfp an `/og/<slug>.png` image path (unless one is already
# set or the resource is a prototype). In production, a low-priority
# site:post_write hook shells out to scripts/generate-og.mjs
# to render the PNGs from the rendered HTML.
class Builders::OgImages < SiteBuilder
  # Registers the image-assignment hook, the production render hook, and the
  # `og_slug` view helper.
  # @return [void]
  def build
    hook :resources, :post_read do |resource|
      next unless %w[posts projects pages cfps].include?(resource.collection.label)
      next if resource.data.image
      next if resource.data.prototype

      resource.data.image = "/og/#{OgHelper.slug(resource)}.png"
    end

    if Bridgetown.env.production?
      hook :site, :post_write, priority: :low do |_site|
        Bridgetown.logger.info "OG:", "Generating images from rendered HTML..."
        raise "OG image generation failed" unless system("node", "scripts/generate-og.mjs")
      end
    end

    helper :og_slug do |resource|
      OgHelper.slug(resource)
    end
  end
end

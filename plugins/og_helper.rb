# Derives the stable filename slug used for a resource's generated OG image
# (`/og/<slug>.png`). Shared by Builders::OgImages (which assigns the image
# path) and scripts/generate-og.mjs (which reads it back from rendered HTML).
module OgHelper
  # @param resource [Bridgetown::Resource::Base] the page/post/project resource
  # @return [String] the OG slug ("index" for the homepage, a permalink-derived
  #   slug when a custom permalink is set, otherwise the date-stripped basename)
  def self.slug(resource)
    return "index" if resource.relative_url == "/"

    if (permalink = resource.data.permalink)
      permalink.gsub(/^\/+|\/+$/, "").tr("/", "-")
    else
      File.basename(resource.relative_path, ".*").sub(/^\d{4}-\d{2}-\d{2}-/, "")
    end
  end
end

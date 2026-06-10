# Markdown-authored content images render as bare <img> (kramdown adds no
# loading/decoding hints). Add them post-render: decode async on every image,
# and lazy-load all but the first so the likely LCP image isn't deferred.
class Builders::Inspectors::Images < SiteBuilder
  def build
    return if Bridgetown.env.development?

    inspect_html do |document|
      document.query_selector_all("img").each_with_index do |img, index|
        img[:decoding] = "async" unless img[:decoding]
        next if index.zero?
        img[:loading] = "lazy" unless img[:loading]
      rescue
        warn "Skipped problematic image: #{img}"
      end
    end
  end
end

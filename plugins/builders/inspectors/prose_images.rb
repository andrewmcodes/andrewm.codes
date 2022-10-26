class Builders::Inspectors::ProseImages < SiteBuilder
  def build
    return unless Bridgetown.env.production?

    # TODO: this may not be what we want exactly...
    inspect_html do |document|
      document.query_selector_all(".prose p img").each do |image|
        image[:loading] = "lazy" unless image[:loading]
        image[:width] = 627 unless image[:width]
        image[:height] = 427 unless image[:height]

        unless image[:alt]
          image[:alt] = "TODO"
          logger.warn("[Prose] Image missing alt text: #{image[:src]}")
        end
      end
    end
  end
end

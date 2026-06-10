class Builders::PrototypeMetadata < SiteBuilder
  FIELDS = %w[description seo_title image_alt image].freeze

  def build
    Bridgetown::Hooks.register_one :generated_pages, :post_init do |page|
      next unless page.is_a?(Bridgetown::PrototypePage)
      term_key = page.data.dig("prototype", "term")
      term = term_key && page.data[term_key]
      next unless term

      FIELDS.each do |field|
        value = page.data[field]
        next unless value.is_a?(String) && value.include?(":prototype-term")
        page.data[field] = value.gsub(":prototype-term", term)
      end
    end
  end
end

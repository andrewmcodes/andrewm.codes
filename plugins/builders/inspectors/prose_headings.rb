class Builders::Inspectors::ProseHeadings < SiteBuilder
  def build
    return unless Bridgetown.env.production?

    inspect_html do |document|
      document.query_selector_all(".prose h2[id], .prose h3[id], .prose h4[id], .prose h5[id]").each do |heading|
        heading << document.create_text_node(" ")
        heading << document.create_element(
          "a",
          "#",
          href: "##{heading[:id]}",
          class: "heading-link"
        )
      end
    end
  end
end

class Builders::Inspectors::ProseHeadings < SiteBuilder
  def build
    return if Bridgetown.env.development?

    inspect_html do |document|
      document.query_selector_all(".prose h2[id], .prose h3[id], .prose h4[id], .prose h5[id]").each do |h|
        h.add_child(<<~HTML)
          <a class="heading-anchor" href="##{h["id"]}">#</a>
        HTML
        h.add_class("flex items-center")
      end
    end
  end
end

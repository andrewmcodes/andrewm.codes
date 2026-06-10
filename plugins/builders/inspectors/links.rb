# Post-processes rendered HTML (production only): opens external links in a new
# tab and ensures any new-tab link carries rel="noreferrer", merging it into an
# author-set rel rather than overwriting nofollow/sponsored.
class Builders::Inspectors::Links < SiteBuilder
  # Registers the HTML inspector. No-op in development.
  # @return [void]
  def build
    return if Bridgetown.env.development?

    inspect_html do |document|
      document.query_selector_all("a").each do |anchor|
        external = anchor[:href].to_s.start_with?("http") && !anchor[:href].include?(site.config.url)
        anchor[:target] = "_blank" if external

        # Any link opening in a new tab (external, or already target=_blank)
        # needs rel=noreferrer. Merge it in rather than overwriting so an
        # author-set rel like nofollow/sponsored survives.
        if external || anchor[:target] == "_blank"
          rels = anchor[:rel].to_s.split(/\s+/)
          rels << "noreferrer" unless rels.include?("noreferrer")
          anchor[:rel] = rels.join(" ")
        end
      rescue
        warn "Skipped problematic link: #{anchor}"
      end
    end
  end
end

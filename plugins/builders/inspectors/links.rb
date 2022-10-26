class Builders::Inspectors::Links < SiteBuilder
  def build
    return unless Bridgetown.env.production?

    inspect_html do |document|
      document.query_selector_all("a").each do |anchor|
        error("Found link with no href attribute: #{anchor}") unless anchor[:href]

        # If target = _blank, then make sure rel=noreferrer is set.
        # I cannot think of a case where I don't want this behavior, but
        # I guess we will see.
        if anchor[:target] == "_blank"
          anchor[:rel] = "noreferrer" unless anchor[:rel].include?("noreferrer")
        end

        # If the anchor contains `http` and does not include the site url, then it's external
        if anchor[:href].starts_with?("http") && !anchor[:href].include?(site.config.url)
          anchor[:target] = "_blank"
          anchor[:rel] = "noreferrer"

        # If the anchor starts with a slash, then it's internal.
        # What about when it starts with a `#`? Does that matter?
        elsif anchor[:href].starts_with?("/") # || anchor[:href].starts_with?("#")
          anchor[:href] = site.config.url + anchor[:href]
          anchor[:target] = "_self"
        end
      end
    end
  end
end

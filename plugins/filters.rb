module MyFilters
  def emoji(name, emoji)
    "<span role=\"img\" aria-label=\"#{name.capitalize}\">#{emoji}</span>"
  end

  def title(page)
    (page&.data&.title || site.metadata.title).strip + " | andrewm.codes"
  end

  def description(page)
    page&.data&.description || site.metadata.description
  end

  def json_feed(page)
    {
      version: "https://jsonfeed.org/version/1",
      title: site.metadata.title,
      icon: absolute_url("/icon-192.png"),
      home_page_url: absolute_url("/"),
      feed_url: absolute_url("feed.json"),
      items:
        site
          .posts
          .docs
          .map do |post|
            {
              id: post.url,
              title: post.data.title,
              content_html: post.content,
              date_published: DateTime.rfc3339(post.data.published_at).to_s,
              url: post.url,
            }
          end,
    }.to_json
  end

  def icon(name)
    <<~HTML
      <svg class="icon icon--#{name}" role="img" aria-hidden="true" width="24" height="24">
        <use xlink:href="#icon-#{name}"></use>
      </svg>
    HTML
  end
end

Liquid::Template.register_filter MyFilters
Bridgetown::RubyTemplateView::Helpers.include MyFilters

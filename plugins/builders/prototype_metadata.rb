class Builders::PrototypeMetadata < SiteBuilder
  FIELDS = %w[description seo_title image_alt image].freeze
  MIN_INDEXABLE_TAG_POSTS = 3

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

      next unless tag_page?(page)

      # Bridgetown's prototype generator force-enables pagination, but tag.erb
      # renders the whole tagged list itself and links to no page 2. Left on,
      # the paginator emitted /tag/<term>/page/2/ and /page/3/ — indexable,
      # self-canonical, orphaned byte-copies of page 1.
      page.data["pagination"] = page.data["pagination"].to_h.merge("enabled" => false)

      tagged = tagged_posts(term)
      page.data.description = tag_description(term, tagged)
      page.data.noindex = tagged.size < MIN_INDEXABLE_TAG_POSTS
      page.data.sitemap = false
    end

    hook :site, :pre_render do |site|
      site.config["sitemap"] ||= {}
      existing_urls = Array(site.config.dig("sitemap", "custom_urls"))
        .reject { |url| url["url"].to_s.include?("/tag/") }

      site.config["sitemap"]["custom_urls"] = existing_urls + indexable_tag_sitemap_urls(site)
    end
  end

  private

  def tag_page?(page)
    page.data.kind == "tag" && page.data.dig("prototype", "collection") == "posts"
  end

  def tagged_posts(tag)
    site.collections.posts.resources.select { |post| Array(post.data.tags).include?(tag) }
  end

  # The front-matter description ("Every post ... tagged #x, newest first.")
  # rendered at 61–69 characters, well under the ~155 Google will show. Count
  # and date range are true of the page and read like an archive summary.
  def tag_description(tag, posts)
    return "Posts Andrew Mason has written tagged ##{tag} on Ruby, Rails, and developer tooling, newest first." if posts.empty?

    years = posts.map { |post| post.date.year }.minmax.uniq
    when_ = (years.size == 1) ? "in #{years.first}" : "between #{years.first} and #{years.last}"
    noun = (posts.size == 1) ? "post" : "posts"

    "#{posts.size} #{noun} tagged ##{tag}, published #{when_}. Andrew Mason's notes on Ruby, Rails, " \
      "and developer tooling, newest first."
  end

  def indexable_tag_sitemap_urls(site)
    grouped_posts = site.collections.posts.resources.each_with_object(Hash.new { |h, k| h[k] = [] }) do |post, groups|
      Array(post.data.tags).each { |tag| groups[tag] << post }
    end

    grouped_posts.filter_map do |tag, posts|
      next if posts.size < MIN_INDEXABLE_TAG_POSTS

      latest_post = posts.max_by(&:date)
      {
        "url" => "#{site.config.url}/tag/#{tag_slug(tag)}/",
        "lastmod" => sitemap_lastmod(latest_post)
      }
    end
  end

  def tag_slug(tag)
    tag.to_s.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-|-+\z/, "")
  end

  def sitemap_lastmod(resource)
    value = resource.data.last_modified_at || resource.date
    value.respond_to?(:xmlschema) ? value.xmlschema : value.to_s
  end
end

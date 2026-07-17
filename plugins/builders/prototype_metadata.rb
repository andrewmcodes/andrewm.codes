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

      thin_tag = tag_post_count(term) < MIN_INDEXABLE_TAG_POSTS
      page.data.noindex = thin_tag
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

  def tag_post_count(tag)
    site.collections.posts.resources.count { |post| Array(post.data.tags).include?(tag) }
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

class Builders::TagTaxonomy < SiteBuilder
  TAG_ALIASES = {
    "tailwind-css" => "tailwindcss",
    "vs-code" => "vscode",
    "gh" => "github"
  }.freeze

  def build
    hook :resources, :post_read do |resource|
      next unless resource.collection&.label == "posts"
      next if Array(resource.data.tags).empty?

      resource.data.tags = normalized_tags(resource.data.tags)
    end
  end

  private

  def normalized_tags(tags)
    Array(tags)
      .filter_map { |tag| canonical_tag(tag) }
      .uniq
  end

  def canonical_tag(tag)
    slug = tag.to_s.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-|-+\z/, "")
    return nil if slug.empty?

    TAG_ALIASES.fetch(slug, slug)
  end
end

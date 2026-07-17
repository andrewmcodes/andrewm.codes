module Util
  # Emits document title, meta, Open Graph, Twitter, and canonical tags.
  #
  # @option opts [Bridgetown::Resource::Base] :resource the page being rendered
  # @option opts [String] :title optional title override
  class Seo < Base
    COMPONENT_OPTIONS = %i[resource title].freeze

    private

    # @return [Bridgetown::Resource::Base] the resource being rendered
    def resource
      opts[:resource]
    end

    # @return [String] the page's raw title (override → seo_title → title →
    #   site title), whitespace-collapsed
    def title
      raw = opts[:title] || resource.data.seo_title || resource.data.title || metadata.title
      raw.to_s.strip.gsub(/\s+/, " ")
    end

    # @return [Boolean] whether the current resource is the site homepage
    def homepage?
      resource.respond_to?(:relative_url) && resource.relative_url == "/"
    end

    # @return [String] the +<title>+ text: branded "Title | Site" when it fits
    #   in 60 chars, otherwise the bare title (or the social title on home)
    def page_title
      return social_title if homepage?

      branded = "#{title} | #{metadata.title}"
      return branded if branded.length <= 60

      title
    end

    # @return [String] the title used for OG/Twitter cards
    def social_title
      return metadata.long_title || "#{metadata.title}, #{metadata.tagline}" if homepage?
      title
    end

    # @return [String] the resource description (or site default),
    #   whitespace-collapsed and untruncated
    def description
      desc = resource.data.description || metadata.description
      desc.to_s.strip.gsub(/\s+/, " ")
    end

    # Google clips the meta description ~155–160 chars; OG/Twitter cards allow a
    # little more. Truncate on a word boundary so we never cut mid-word.
    # @return [String] the description capped at 160 chars
    def meta_description
      truncate(description, 160)
    end

    # @return [String] the description capped at 200 chars for social cards
    def social_description
      truncate(description, 200)
    end

    # @param text [String] the source text
    # @param max [Integer] the maximum length (including the ellipsis)
    # @return [String] +text+ truncated on a word boundary with a trailing "…"
    def truncate(text, max)
      return text if text.length <= max

      cut = text[0, max - 1].to_s
      cut = cut.sub(/\s+\S*\z/, "") if cut.include?(" ")
      "#{cut.rstrip}…"
    end

    # @return [String] the absolute image URL (external URLs pass through)
    def image
      image_url = resource.data.image || metadata.image
      return image_url if image_url.to_s.start_with?("http")
      helpers.absolute_url(image_url.to_s)
    end

    # The dimension/type triplet below only describes our generated OG cards
    # (1200×630 PNG). A custom/Cloudinary `image:` may be any size or format, so
    # we must not assert those values for it.
    # @return [Boolean] whether the OG image is a generated /og/*.png
    def og_generated_image?
      image.to_s.match?(%r{/og/[^/]+\.png\z})
    end

    # @return [String] alt text for the OG/Twitter image
    def image_alt
      return resource.data.image_alt if resource.data.image_alt
      homepage? ? social_title : "#{social_title} | #{metadata.title}"
    end

    # @param value [#iso8601, Object, nil] a date/time-like value
    # @return [String, nil] an ISO 8601 string, or nil when +value+ is nil
    def iso_date(value)
      return nil if value.nil?
      value.respond_to?(:iso8601) ? value.iso8601 : value.to_s
    end

    # @return [Array<String>] the resource's unique, compacted tags
    def article_tags
      Array(resource.data.tags).compact.uniq
    end

    # @return [String] the absolute canonical URL of the current page
    def page_url
      resource.respond_to?(:absolute_url) ? resource.absolute_url : helpers.absolute_url(resource.url)
    end

    # @return [String] the explicit canonical_url front matter, else the page URL
    def canonical_url
      return resource.data.canonical_url if resource.data.canonical_url
      page_url
    end

    # @return [Bridgetown::Site::Metadata] the site metadata
    def metadata
      @metadata ||= @site.metadata
    end

    # @param res [Bridgetown::Resource::Base] a resource
    # @return [Boolean] whether +res+ belongs to the posts collection
    def post?(res)
      res.respond_to?(:collection) && res.collection&.label == "posts"
    end

    # @return ["article", "website"] the Open Graph object type
    def page_type
      post?(resource) ? "article" : "website"
    end

    # @return [Boolean] whether the page is an article (og:type article)
    def article?
      page_type == "article"
    end

    # Builds the full set of meta/OG/Twitter/article tags for the page.
    # @return [Array<Hash>] tag descriptors ({name:|property:, content:})
    def meta_tags_data
      meta = [
        {name: "description", content: meta_description},
        {name: "author", content: metadata.author.name},
        {property: "og:title", content: social_title},
        {property: "og:description", content: social_description},
        {property: "og:image", content: image},
        {property: "og:image:secure_url", content: image}
      ]

      if og_generated_image?
        meta << {property: "og:image:type", content: "image/png"}
        meta << {property: "og:image:width", content: "1200"}
        meta << {property: "og:image:height", content: "630"}
      end

      meta.concat([
        {property: "og:image:alt", content: image_alt},
        {property: "og:url", content: canonical_url},
        {property: "og:site_name", content: metadata.title},
        {property: "og:type", content: page_type},
        {property: "og:locale", content: "en_US"},
        {name: "twitter:card", content: "summary_large_image"},
        {name: "twitter:site", content: "@#{metadata.author.twitter}"},
        {name: "twitter:creator", content: "@#{metadata.author.twitter}"},
        {name: "twitter:title", content: social_title},
        {name: "twitter:description", content: social_description},
        {name: "twitter:image", content: image},
        {name: "twitter:image:alt", content: image_alt}
      ])

      if article?
        published = iso_date(resource.data.date)
        meta << {property: "article:published_time", content: published} if published
        if (modified = article_modified)
          meta << {property: "article:modified_time", content: modified}
        end
        meta << {property: "article:author", content: metadata.author.name}
        article_tags.each { |tag| meta << {property: "article:tag", content: tag} }
      end

      meta
    end

    # Mirrors Util::StructuredData#date_modified so OG and JSON-LD agree on the
    # post's modified time (explicit override → updated_at → publish date).
    # @return [String, nil] the ISO 8601 modified time
    def article_modified
      raw = (resource.respond_to?(:updated_at) && resource.updated_at) ||
        resource.data.last_modified_at || resource.data.date
      iso_date(raw)
    end

    # @return [Array<Hash>] <link> descriptors; a canonical link unless the page
    #   opts out (canonical_url: false) or is noindex
    def extra_links_data
      # @type var links: Array[Hash[Symbol, untyped]]
      links = []
      unless resource.data.canonical_url == false || resource.data.noindex == true
        links << {rel: "canonical", href: canonical_url}
      end
      links
    end
  end
end

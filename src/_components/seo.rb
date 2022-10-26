class Seo < Base
  COMPONENT_OPTIONS = [:resource, :title]

  private

  def resource
    opts[:resource]
  end

  def title
    opts[:title] || resource.data.title || metadata.title
  end

  def description
    resource.data.description || metadata.description
  end

  def image
    image_url = resource.data.image || metadata.image
    return image_url if image_url.start_with?("http")

    absolute_url(image_url)
  end

  def metadata
    @metadata ||= site.metadata
  end

  def page_type
    return "article" if post?(resource) && resource.data.date

    "website"
  end

  def article?
    page_type == "article"
  end

  def meta_tags_data
    meta = [
      {name: "description", content: description},
      {property: "og:title", content: title},
      {property: "og:description", content: description},
      {property: "og:image", name: "image", content: image},
      {property: "og:url", content: resource.try(:absolute_url) || absolute_url(resource)},
      {property: "og:site_name", content: metadata.sitename},
      {property: "og:type", content: page_type},
      {name: "twitter:card", content: "summary_large_image"},
      {name: "twitter:site", content: "@#{metadata.author.twitter}"},
      {name: "twitter:creator", content: "@#{metadata.author.twitter}"},
      {name: "twitter:title", content: title},
      {name: "twitter:description", content: description},
      {name: "twitter:image", content: image},
      {property: "author", content: metadata.author.name},
      {property: "generator", content: metadata.generator},
      {name: "theme-color", media: "(prefers-color-scheme: light)", content: metadata.theme_color.light},
      {name: "theme-color", media: "(prefers-color-scheme: dark)", content: metadata.theme_color.dark}
    ]

    if resource.data.date
      meta << {property: "article:published_time", content: resource.data.date}
      meta << {property: "article:publish_date", content: resource.data.date}
      meta << {property: "article:modified_time", content: resource.data.last_modified_at}
      meta << {property: "article:author", content: metadata.author.name}
    end

    meta
  end

  def asset_links_data
    [
      {
        rel: "stylesheet",
        href: webpack_path(:css),
        "data-turbo-track": "reload"
      },
      {
        rel: "icon",
        type: "image/svg+xml",
        href: absolute_url("public/favicon.svg")
      },
      {
        rel: "icon",
        type: "image/png",
        href: absolute_url("public/favicon.png")
      },
      {
        rel: "apple-touch-icon",
        href: absolute_url("public/apple-touch-icon.png")
      }
    ]
  end

  def extra_links_data
    links = [
      {type: "application/json", rel: "alternate", title: "JSON Feed", href: absolute_url("feed.json")},
      {rel: "webmention", href: "https://webmention.io/andrewm.codes/webmention"},
      {rel: "pingback", href: "https://webmention.io/andrewm.codes/xmlrpc"},
      {rel: "me", href: "https://andrewm.codes"},
      {rel: "me", href: "https://twitter.com/andrewmcodes"},
      {rel: "me", href: "https://github.com/andrewmcodes"}
    ]
    links << {rel: "canonical", href: (resource.data.canonical_url || absolute_url(resource))} unless resource.data.canonical_url == false || resource.data.noindex == true
    links
  end

  def json_ld
    store = {
      "@context" => "https://schema.org",
      "@graph" => [
        {
          "@type" => "WebSite",
          "@id" => absolute_url("/#website"),
          "url" => absolute_url("/"),
          "name" => metadata.title,
          "description" => metadata.description,
          "inLanguage" => "en-US"
        },
        {
          "@type" => (article? ? "BlogPosting" : "Website"),
          "mainEntityOfPage" => {
            "@type": "WebPage"
          },
          "isPartOf" => {
            "@id": absolute_url("/#website").to_s
          },
          "headline" => title,
          "description" => description,
          "image" => image,
          "inLanguage" => "en-US",
          "publisher" => {
            "@type" => "Organization",
            "name" => metadata.author.name,
            "url" => absolute_url("/")
          },
          "author" => {
            "@type" => "Person",
            "url" => absolute_url("/"),
            "name" => metadata.author.name
          },
          "keywords" => Array(resource.data.tags)&.to_sentence,
          "datePublished" => date_to_xmlschema(resource.data.date),
          "dateModified" => date_to_xmlschema(resource.data.last_modified_at)
        }
      ]
    }
    store["@graph"][1].delete(:author) unless article?
    store["@graph"][1].delete(:keywords) unless article?
    store["@graph"][1].delete(:datePublished) unless article?
    store["@graph"][1].delete(:dateModified) unless article?

    jsonify(store)
  end
end

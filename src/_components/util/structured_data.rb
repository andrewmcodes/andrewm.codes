require "time"

module Util
  # Emits schema.org JSON-LD for the current resource.
  #
  # One canonical Person/WebSite entity (referenced by `@id`) is reused across
  # pages so search engines resolve a single author/site entity. Every schema is
  # built from real resource/site data only — absent fields are dropped, never
  # invented.
  class StructuredData < Base
    COMPONENT_OPTIONS = %i[resource].freeze

    private

    def resource
      opts[:resource]
    end

    def metadata
      @metadata ||= @site.metadata
    end

    # ---- Shared entities -----------------------------------------------------

    def site_url
      @site_url ||= @site.config.url.to_s.chomp("/")
    end

    def person_id = "#{site_url}/#person"

    def website_id = "#{site_url}/#website"

    def about_url = "#{site_url}/about/"

    # The full Person node. Referenced elsewhere via `person_ref`.
    def person
      {
        "@type" => "Person",
        "@id" => person_id,
        "name" => metadata.author.name,
        "url" => about_url,
        "image" => helpers.absolute_url(metadata.image),
        "jobTitle" => metadata.author.job_title,
        "description" => metadata.author.bio,
        "worksFor" => org(metadata.author.works_for),
        "knowsAbout" => knows_about,
        "sameAs" => same_as
      }.compact
    end

    def knows_about
      list = Array(metadata.author.knows_about).map(&:to_s).reject(&:empty?)
      list.empty? ? nil : list
    end

    def person_ref = {"@type" => "Person", "@id" => person_id}

    def website_ref = {"@type" => "WebSite", "@id" => website_id}

    def org(name)
      return nil if name.to_s.empty?
      {"@type" => "Organization", "name" => name}
    end

    def same_as
      Array(metadata.social&.links).map(&:to_s).reject(&:empty?).uniq
    end

    def website
      {
        "@type" => "WebSite",
        "@id" => website_id,
        "url" => "#{site_url}/",
        "name" => metadata.title,
        "description" => metadata.description,
        "inLanguage" => metadata.lang,
        "publisher" => person_ref,
        "potentialAction" => search_action
      }
    end

    # Enables Google's sitelinks search box. Targets the /search/ page, which
    # reads ?q= and renders matches from the same search.json the palette uses.
    def search_action
      {
        "@type" => "SearchAction",
        "target" => {
          "@type" => "EntryPoint",
          "urlTemplate" => "#{site_url}/search/?q={search_term_string}"
        },
        "query-input" => "required name=search_term_string"
      }
    end

    # ---- Helpers -------------------------------------------------------------

    def collection_label
      resource.respond_to?(:collection) ? resource.collection&.label : nil
    end

    def rel_url
      resource.respond_to?(:relative_url) ? resource.relative_url : nil
    end

    def abs_url(res = resource)
      res.respond_to?(:absolute_url) ? res.absolute_url : helpers.absolute_url(res.relative_url)
    end

    def resource_image(res)
      helpers.absolute_url(res.data.image || metadata.image)
    end

    # schema.org image URLs must be absolute. Leave an already-absolute URL
    # (e.g. external podcast artwork) untouched; absolutize a site-relative one.
    # @param url [String, nil] an image URL
    # @return [String, nil] an absolute URL, or nil when blank
    def absolute_image(url)
      return nil if url.to_s.empty?
      url.to_s.start_with?("http") ? url.to_s : helpers.absolute_url(url.to_s)
    end

    def iso(value)
      return nil if value.nil?
      value.respond_to?(:iso8601) ? value.iso8601 : value.to_s
    end

    def iso_from_string(value)
      return nil if value.to_s.empty?
      ::Time.parse(value.to_s).iso8601
    rescue ArgumentError
      value.to_s
    end

    # Explicit last_modified_at when curated, otherwise the publish date — an
    # unmodified post's modified date equals its publish date. (Git commit dates
    # aren't used: this repo is a fresh import, so they'd falsely mark every old
    # post as recently modified.)
    def date_modified(res)
      raw = (res.respond_to?(:updated_at) && res.updated_at) || res.data.last_modified_at || res.date
      iso(raw)
    end

    def keywords(res)
      tags = Array(res.data.tags).compact.uniq
      tags.empty? ? nil : tags.join(", ")
    end

    def posts = @site.collections.posts.resources

    # ---- Schema assembly -----------------------------------------------------

    # @return [Array<Hash>] every schema.org node for the page (primary entity
    #   plus an optional breadcrumb), nils removed
    def schemas
      (primary_schemas + [breadcrumb_schema]).compact
    end

    def primary_schemas
      case collection_label
      when "posts" then [blog_posting]
      when "cfps" then [cfp_article]
      else page_schemas
      end
    end

    def page_schemas
      case rel_url
      when "/" then [website, person]
      when "/about/" then [profile_page]
      when "/posts/" then [blog_listing]
      when "/projects/" then [projects_collection]
      when "/speaking/" then speaking_schemas
      else tag_page? ? [tag_collection] : []
      end
    end

    # ---- Article-like schemas ------------------------------------------------

    def blog_posting
      article("BlogPosting")
    end

    def cfp_article
      article("Article")
    end

    # @param type [String] schema.org type ("BlogPosting" or "Article")
    # @return [Hash] the article node, absent fields dropped
    def article(type)
      {
        "@type" => type,
        "headline" => resource.data.title,
        "description" => resource.data.description,
        "datePublished" => iso(resource.date),
        "dateModified" => date_modified(resource),
        "author" => person,
        "publisher" => person_ref,
        "image" => resource_image(resource),
        "url" => abs_url,
        "mainEntityOfPage" => abs_url,
        "inLanguage" => metadata.lang,
        "isPartOf" => website_ref,
        "keywords" => keywords(resource),
        "wordCount" => word_count,
        "isAccessibleForFree" => (true if type == "BlogPosting")
      }.compact
    end

    def word_count
      return nil unless resource.respond_to?(:word_count)
      count = resource.word_count
      count.positive? ? count : nil
    end

    # ---- Page schemas --------------------------------------------------------

    def profile_page
      {
        "@type" => "ProfilePage",
        "url" => abs_url,
        "name" => resource.data.title,
        "description" => resource.data.description,
        "inLanguage" => metadata.lang,
        "mainEntity" => person
      }.compact
    end

    def blog_listing
      {
        "@type" => "Blog",
        "url" => abs_url,
        "name" => metadata.title,
        "description" => metadata.description,
        "inLanguage" => metadata.lang,
        "publisher" => person_ref,
        "blogPost" => posts.first(10).map { |p|
          {
            "@type" => "BlogPosting",
            "headline" => p.data.title,
            "url" => p.absolute_url,
            "datePublished" => iso(p.date),
            "author" => person_ref
          }
        }
      }
    end

    def projects_collection
      item_list_page(@site.collections.projects.resources) { |p| p.data.repo || p.data.url }
    end

    def tag_collection
      tag = resource.data.tag
      tagged = posts.select { |p| Array(p.data.tags).include?(tag) }.sort_by(&:date).reverse
      item_list_page(tagged, name: "Posts tagged ##{tag}") { |p| p.absolute_url }
    end

    # @param items [Array<Bridgetown::Resource::Base>] the collection items
    # @param name [String] the CollectionPage name
    # @yield [item] block returning the canonical URL for an item
    # @return [Hash] a CollectionPage wrapping an ItemList
    def item_list_page(items, name: resource.data.title)
      {
        "@type" => "CollectionPage",
        "url" => abs_url,
        "name" => name,
        "description" => resource.data.description,
        "inLanguage" => metadata.lang,
        "mainEntity" => {
          "@type" => "ItemList",
          "itemListElement" => items.each_with_index.map { |item, i|
            {"@type" => "ListItem", "position" => i + 1, "url" => yield(item), "name" => item.data.title}
          }
        }
      }.compact
    end

    # ---- Speaking: talks (VideoObject) + podcasts ----------------------------

    def speaking_schemas
      talk_videos + podcast_series + [latest_episode].compact
    end

    def talk_videos
      Array(@site.data.talks).filter_map { |talk| talk_video(talk) }
    end

    def talk_video(talk)
      href = recording_url(talk)
      return nil unless href
      {
        "@type" => "VideoObject",
        "name" => talk["title"],
        "description" => talk["excerpt"],
        "uploadDate" => iso(talk["date"]),
        "url" => href,
        "contentUrl" => href,
        "duration" => duration_from_minutes(talk["duration"]),
        "thumbnailUrl" => youtube_thumbnail(href)
      }.compact
    end

    def recording_url(talk)
      link = Array(talk["links"]).find { |l| (l["label"] || l[:label]).to_s.casecmp("video").zero? }
      link && (link["href"] || link[:href])
    end

    def podcast_series
      Array(@site.data.podcasts).filter_map do |pod|
        url = pod["url"].to_s
        next if url.empty? || url == "#"
        {
          "@type" => "PodcastSeries",
          "@id" => url,
          "name" => pod["name"],
          "url" => url,
          "description" => pod["tagline"],
          "image" => absolute_image(pod["image"])
        }.compact
      end
    end

    def latest_episode
      ep = @site.data.remote_ruby
      return nil unless ep
      series = Array(@site.data.podcasts).find { |p| p["slug"] == "remote-ruby" }
      {
        "@type" => "PodcastEpisode",
        "name" => ep["title"],
        "url" => ep["url"],
        "datePublished" => iso_from_string(ep["published_at"]),
        "duration" => duration_from_seconds(ep["duration"]),
        "episodeNumber" => ep["episode_number"],
        "description" => plain_text(ep["description"]),
        "image" => absolute_image(ep["artwork_url"]),
        "partOfSeries" => series_ref(series)
      }.compact
    end

    def series_ref(series)
      return nil unless series && series["url"].to_s != "" && series["url"] != "#"
      {"@type" => "PodcastSeries", "@id" => series["url"], "name" => series["name"]}
    end

    # ---- Breadcrumbs ---------------------------------------------------------

    def breadcrumb_schema
      trail =
        case collection_label
        when "posts" then [home_crumb, posts_crumb, [resource.data.title, abs_url]]
        when "cfps" then [home_crumb, ["Speaking", "#{site_url}/speaking/"], [resource.data.title, abs_url]]
        else
          [home_crumb, posts_crumb, ["##{resource.data.tag}", abs_url]] if tag_page?
        end
      return nil unless trail

      {
        "@type" => "BreadcrumbList",
        "itemListElement" => trail.each_with_index.map { |(name, url), i|
          {"@type" => "ListItem", "position" => i + 1, "name" => name, "item" => url}
        }
      }
    end

    def home_crumb = ["Home", "#{site_url}/"]

    def posts_crumb = ["Posts", "#{site_url}/posts/"]

    def tag_page?
      d = resource.respond_to?(:data) ? resource.data : nil
      d.respond_to?(:kind) && d.kind == "tag" && d.tag
    end

    # ---- Duration / text utilities -------------------------------------------

    # @param str [String, nil] a duration like "30 min"
    # @return [String, nil] an ISO 8601 duration ("PT30M"), or nil
    def duration_from_minutes(str)
      minutes = str.to_s[/\d+/]
      minutes && "PT#{minutes}M"
    end

    # @param seconds [Integer, String, nil] a duration in seconds
    # @return [String, nil] an ISO 8601 duration ("PT1H2M3S"), or nil if <= 0
    def duration_from_seconds(seconds)
      total = seconds.to_i
      return nil if total <= 0
      hours, rest = total.divmod(3600)
      mins, secs = rest.divmod(60)
      duration = +"PT"
      duration << "#{hours}H" if hours.positive?
      duration << "#{mins}M" if mins.positive?
      duration << "#{secs}S" if secs.positive?
      duration
    end

    # @param url [String] a YouTube watch/short URL
    # @return [String, nil] the maxres thumbnail URL, or nil if not YouTube
    def youtube_thumbnail(url)
      id = youtube_id(url)
      id && "https://i.ytimg.com/vi/#{id}/maxresdefault.jpg"
    end

    # @param url [String] a YouTube URL
    # @return [String, nil] the 11-char video id, or nil
    def youtube_id(url)
      case url.to_s
      when /[?&]v=([\w-]{11})/ then $1
      when %r{youtu\.be/([\w-]{11})} then $1
      end
    end

    # @param value [String, nil] HTML or text
    # @param limit [Integer] max length before truncation
    # @return [String] HTML-stripped, whitespace-collapsed text, truncated with "…"
    def plain_text(value, limit: 300)
      text = value.to_s.gsub(/<[^>]+>/, " ").gsub("&nbsp;", " ").gsub(/\s+/, " ").strip
      (text.length > limit) ? "#{text[0, limit - 1]}…" : text
    end
  end
end

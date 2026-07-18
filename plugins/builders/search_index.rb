require "json"

class Builders::SearchIndex < SiteBuilder
  PINNED = [
    {title: "Home", url: "/", kind: "page", pinned: true},
    {title: "Posts", url: "/posts/", kind: "page", pinned: true},
    {title: "Projects", url: "/projects/", kind: "page", pinned: true},
    {title: "Speaking", url: "/speaking/", kind: "page", pinned: true},
    {title: "Uses", url: "/uses/", kind: "page", pinned: true},
    {title: "About", url: "/about/", kind: "page", pinned: true},
    {title: "Search", url: "/search/", kind: "page", pinned: true},
    {title: "Changelog", url: "/changelog/", kind: "page", pinned: true}
  ].freeze

  def build
    hook :site, :post_write do |site|
      next unless site.config.destination

      entries = PINNED.map(&:dup)

      site.collections.posts.resources.each do |r|
        entries << {
          title: r.data.title.to_s,
          url: r.relative_url.to_s,
          kind: "post",
          tags: Array(r.data.tags).join(",")
        }
      end

      site.collections.cfps.resources.each do |r|
        entries << {
          title: r.data.title.to_s,
          url: r.relative_url.to_s,
          kind: "cfp",
          tags: Array(r.data.tags).join(",")
        }
      end

      site.collections.projects.resources.each do |r|
        entries << {
          title: r.data.title.to_s,
          url: external_url(r.data.repo || r.data.url, fallback: "/projects/"),
          kind: "project",
          tags: [r.data.description, r.data.lang, r.data.status].compact.join(",")
        }
      end

      Array(site.data.talks).each do |talk|
        entries << {
          title: talk["title"].to_s,
          url: external_url(first_link(talk), fallback: "/speaking/"),
          kind: "talk",
          tags: [talk["venue"], talk["city"], talk["excerpt"]].compact.join(",")
        }
      end

      Array(site.data.podcasts).each do |podcast|
        entries << {
          title: podcast["name"].to_s,
          url: external_url(podcast["url"], fallback: "/speaking/"),
          kind: "podcast",
          tags: [podcast["role"], podcast["tagline"], podcast["schedule"]].compact.join(",")
        }
      end

      if (episode = site.data.remote_ruby)
        entries << {
          title: episode["title"].to_s,
          url: external_url(episode["url"], fallback: "/speaking/"),
          kind: "episode",
          tags: ["Remote Ruby", plain_text(episode["description"])].compact.join(",")
        }
      end

      File.write(
        File.join(site.config.destination, "search.json"),
        JSON.generate(entries)
      )
    end
  end

  private

  def first_link(talk)
    Array(talk["links"]).first&.fetch("href", nil)
  end

  def external_url(url, fallback:)
    url = url.to_s
    return fallback if url.empty? || url == "#"
    return "https://#{url}" if url.start_with?("www.", "youtube.com")

    url
  end

  def plain_text(value)
    value.to_s.gsub(/<[^>]+>/, " ").gsub(/\s+/, " ").strip
  end
end

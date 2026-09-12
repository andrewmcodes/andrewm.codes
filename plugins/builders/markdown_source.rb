# Emits LLM-friendly Markdown alongside the HTML build, mirroring the
# "Copy page / View as Markdown" affordance on docs sites like code.claude.com:
#
#   * /index.md and .md twins of the site's content and archive pages.
#   * /p/<slug>.md and /cfps/<slug>.md — Markdown twins of post-like resources.
#   * /llms.txt      — an index of those Markdown files (see llmstxt.org).
#   * /llms-full.txt — the exported site content concatenated into one document.
#
# Files are written at :site, :post_write into the build destination — the
# same pattern as Builders::Redirects. No environment guard: it's cheap enough
# to run in dev and test, so the on-page control works everywhere.
class Builders::MarkdownSource < SiteBuilder
  POST_COLLECTIONS = %w[posts cfps].freeze
  GENERATED_PAGE_PATHS = {
    "/changelog/" => :changelog_document,
    "/posts/" => :posts_document,
    "/projects/" => :projects_document,
    "/speaking/" => :speaking_document
  }.freeze

  def build
    helper :markdown_source_path do |resource|
      Builders::MarkdownSource.path_for(resource)
    end

    hook :site, :post_write do |site|
      destination = site.config.destination
      next unless destination

      resources = Builders::MarkdownSource.exported_resources(site)

      resources.each do |resource|
        path = File.join(destination, Builders::MarkdownSource.path_for(resource).delete_prefix("/"))
        FileUtils.mkdir_p(File.dirname(path))
        File.write(path, markdown_document(site, resource))
      end

      File.write(File.join(destination, "index.md"), home_document(site))
      File.write(File.join(destination, "llms.txt"), llms_index(site, resources))
      File.write(File.join(destination, "llms-full.txt"), llms_full(site, resources))
    end
  end

  class << self
    def exported_resources(site)
      posts = POST_COLLECTIONS
        .flat_map { |label| site.collections[label]&.resources || [] }
        .sort_by(&:date)
        .reverse
      pages = (site.collections["pages"]&.resources || [])
        .select { |resource| markdown_authored?(resource) || GENERATED_PAGE_PATHS.key?(resource.relative_url) }
        .sort_by { |resource| resource.data.title.to_s }

      posts + pages
    end

    def path_for(resource)
      return "/index.md" if resource.relative_url == "/"
      return unless exportable?(resource)

      "#{resource.relative_url.chomp("/")}.md"
    end

    private

    def exportable?(resource)
      return false unless resource.respond_to?(:collection)

      label = resource.collection&.label
      POST_COLLECTIONS.include?(label) ||
        (label == "pages" && (markdown_authored?(resource) || GENERATED_PAGE_PATHS.key?(resource.relative_url)))
    end

    def markdown_authored?(resource)
      File.extname(resource.relative_path.to_s) == ".md"
    end
  end

  private

  # Clean Markdown: H1 title, description as a blockquote, then the raw
  # (pre-render) Markdown body. `untransformed_content` is captured before the
  # Markdown->HTML transform, so code fences and wikilinks stay intact.
  def markdown_document(site, resource)
    generated_document = GENERATED_PAGE_PATHS[resource.relative_url]
    return send(generated_document, site, resource) if generated_document

    doc = "# #{resource.data.title}\n\n"
    description = resource.data.description.to_s.strip
    doc << "> #{description}\n\n" unless description.empty?
    doc << "#{resource.untransformed_content.to_s.strip}\n"
    doc
  end

  def llms_index(site, resources)
    pages, posts = resources.partition { |resource| resource.collection&.label == "pages" }
    lines = ["# #{site.metadata.title}", "", "> #{site.metadata.description}", "", "## Key pages", ""]
    lines << "- [Home](#{absolute_markdown_url(site, "/index.md")}): #{site.metadata.description}"
    lines.concat(pages.map { |resource| index_entry(resource) })
    lines.concat(["", "## Writing", ""])
    lines.concat(posts.map { |resource| index_entry(resource) })
    "#{lines.join("\n")}\n"
  end

  def llms_full(site, resources)
    header = home_document(site)
    body = resources.map { |resource| markdown_document(site, resource) }.join("\n---\n\n")
    "#{header}\n---\n\n#{body}"
  end

  def home_document(site)
    selected_posts = Array(site.data.selected_posts).filter_map do |slug|
      site.collections.posts.resources.find { |post| post.relative_url.split("/").reject(&:empty?).last == slug.to_s }
    end

    lines = [
      "# #{site.metadata.title}",
      "",
      "> #{site.metadata.description}",
      "",
      site.metadata.author.bio,
      "",
      "## Explore",
      "",
      "- [Writing](#{site.config.url}/posts/)",
      "- [Projects](#{site.config.url}/projects/)",
      "- [Speaking](#{site.config.url}/speaking/)",
      "- [Uses](#{site.config.url}/uses.md)",
      "- [About](#{site.config.url}/about.md)",
      "",
      "## Selected writing",
      ""
    ]
    lines.concat(selected_posts.map { |post| index_entry(post) })
    "#{lines.join("\n")}\n"
  end

  def index_entry(resource)
    description = resource.data.description.to_s.strip
    entry = "- [#{resource.data.title}](#{markdown_url(resource)})"
    entry += ": #{description}" unless description.empty?
    entry
  end

  def posts_document(site, resource)
    posts = site.collections.posts.resources.sort_by(&:date).reverse
    document_with_entries(resource, posts.map { |post| index_entry(post) })
  end

  def projects_document(site, resource)
    projects = Array(site.data.oss).sort_by { |project| project["pushedAt"].to_s }.reverse
    entries = projects.map do |project|
      description = project["description"].to_s.strip
      details = [
        project.dig("primaryLanguage", "name"),
        count_label(project["stargazerCount"], "star"),
        count_label(project["forkCount"], "fork")
      ].compact
      entry = "- [#{project["name"]}](#{project["url"]})"
      entry += ": #{description}" unless description.empty?
      entry += " (#{details.join(", ")})" unless details.empty?
      entry
    end
    document_with_entries(resource, entries)
  end

  def speaking_document(site, resource)
    sections = []
    sections << markdown_section("Podcasts", Array(site.data.podcasts).map do |podcast|
      details = [podcast["role"], podcast["active"] ? "current" : podcast["since"]].compact.join(", ")
      title = (podcast["url"] == "#") ? podcast["name"] : "[#{podcast["name"]}](#{podcast["url"]})"
      "- #{title}: #{podcast["tagline"]} (#{details})"
    end)
    sections << markdown_section("Talks", Array(site.data.talks).sort_by { |talk| talk["date"] }.reverse.map do |talk|
      link = Array(talk["links"]).first&.fetch("href", nil)
      title = link ? "[#{talk["title"]}](#{link})" : talk["title"]
      "- #{title}: #{talk["excerpt"]} (#{talk["venue"]}, #{talk["date"]})"
    end)
    sections << markdown_section("CFPs", site.collections.cfps.resources.sort_by(&:date).reverse.map do |cfp|
      "- [#{cfp.data.title}](#{markdown_url(cfp)}): #{cfp.data.description}"
    end)
    sections << markdown_section("Appearances", Array(site.data.appearances).sort_by { |item| item["date"].to_s }.reverse.map do |item|
      "- [#{item["title"]}](#{item["url"]}): #{item["description"]} (#{item["event"]}, #{item["date"]})"
    end)

    "#{document_header(resource)}#{sections.join("\n\n")}\n"
  end

  def changelog_document(site, resource)
    "#{document_header(resource)}#{site.data.changelog.to_s.strip}\n"
  end

  def document_with_entries(resource, entries)
    "#{document_header(resource)}#{entries.join("\n")}\n"
  end

  def document_header(resource)
    header = "# #{resource.data.title}\n\n"
    description = resource.data.description.to_s.strip
    header << "> #{description}\n\n" unless description.empty?
    header
  end

  def markdown_section(title, entries)
    "## #{title}\n\n#{entries.join("\n")}"
  end

  def count_label(value, noun)
    return unless value

    "#{value} #{noun}#{"s" unless value == 1}"
  end

  # Absolute .md URL, e.g. "https://andrewm.codes/p/kill-process-on-port.md".
  def markdown_url(resource)
    "#{resource.absolute_url.chomp("/")}.md"
  end

  def absolute_markdown_url(site, path)
    "#{site.config.url}#{path}"
  end
end

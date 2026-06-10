# Emits LLM-friendly Markdown alongside the HTML build, mirroring the
# "Copy page / View as Markdown" affordance on docs sites like code.claude.com:
#
#   * /p/<slug>.md and /cfps/<slug>.md — a clean Markdown twin of each
#     post-like resource (title, description, body), served verbatim by
#     Workers Static Assets.
#   * /llms.txt      — an index of those Markdown files (see llmstxt.org).
#   * /llms-full.txt — every post's Markdown concatenated into one document.
#
# Files are written at :site, :post_write into the build destination — the
# same pattern as Builders::Redirects. No environment guard: it's cheap enough
# to run in dev and test, so the on-page control works everywhere.
class Builders::MarkdownSource < SiteBuilder
  # Post-like collections that get a .md twin and appear in the indexes.
  EXPORTED_COLLECTIONS = %w[posts cfps].freeze

  def build
    hook :site, :post_write do |site|
      destination = site.config.destination
      next unless destination

      resources = exported_resources(site)

      resources.each do |resource|
        path = File.join(destination, markdown_path(resource))
        FileUtils.mkdir_p(File.dirname(path))
        File.write(path, markdown_document(resource))
      end

      File.write(File.join(destination, "llms.txt"), llms_index(site, resources))
      File.write(File.join(destination, "llms-full.txt"), llms_full(site, resources))
    end
  end

  private

  # Newest-first across every exported collection.
  def exported_resources(site)
    EXPORTED_COLLECTIONS
      .flat_map { |label| site.collections[label]&.resources || [] }
      .sort_by(&:date)
      .reverse
  end

  # "/p/kill-process-on-port/" -> "p/kill-process-on-port.md"
  def markdown_path(resource)
    "#{resource.relative_url.chomp("/").delete_prefix("/")}.md"
  end

  # Clean Markdown: H1 title, description as a blockquote, then the raw
  # (pre-render) Markdown body. `untransformed_content` is captured before the
  # Markdown->HTML transform, so code fences and wikilinks stay intact.
  def markdown_document(resource)
    doc = "# #{resource.data.title}\n\n"
    description = resource.data.description.to_s.strip
    doc << "> #{description}\n\n" unless description.empty?
    doc << "#{resource.untransformed_content.to_s.strip}\n"
    doc
  end

  def llms_index(site, resources)
    lines = ["# #{site.metadata.title}", "", "> #{site.metadata.description}", "", "## Posts", ""]
    lines += resources.map do |resource|
      description = resource.data.description.to_s.strip
      entry = "- [#{resource.data.title}](#{markdown_url(resource)})"
      entry += ": #{description}" unless description.empty?
      entry
    end
    "#{lines.join("\n")}\n"
  end

  def llms_full(site, resources)
    header = "# #{site.metadata.title}\n\n> #{site.metadata.description}\n"
    body = resources.map { |resource| markdown_document(resource) }.join("\n---\n\n")
    "#{header}\n#{body}"
  end

  # Absolute .md URL, e.g. "https://andrewm.codes/p/kill-process-on-port.md".
  def markdown_url(resource)
    "#{resource.absolute_url.chomp("/")}.md"
  end
end

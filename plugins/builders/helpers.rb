# Registers the site's ERB view helpers. Each `helper :name` block becomes a
# method available in templates.
#
# Registered helpers:
# - +build_title(resource)+ → page-appropriate +<title>+ text
# - +github_edit_url(resource)+ → "edit this page on GitHub" URL
# - +latest_commit_sha+ / +latest_commit_url+ → footer build-provenance links
# - +related_posts(resource, limit = 4)+ → tag-overlap related posts
# - +should_show_toc(resource)+ → whether to render a table of contents
class Builders::Helpers < SiteBuilder
  # Registers all view helpers. Runs once during site setup.
  # @return [void]
  def build
    # Resolve the deploy commit once at build time rather than shelling out to
    # git on every page. CF_PAGES_COMMIT_SHA (Cloudflare) and GITHUB_SHA (CI)
    # are preferred; local builds fall back to `git rev-parse`.
    commit_sha = resolve_commit_sha

    helper :build_title do |resource|
      if resource.relative_url == "/"
        site.metadata.long_title
      else
        resource.data.title || "#{site.metadata.title} #{site.metadata.tagline}"
      end
    end

    helper :github_edit_url do |resource|
      "https://github.com/#{site.metadata.repo}/blob/main/src/#{resource.relative_path}"
    end

    helper :latest_commit_sha do
      commit_sha[0..6]
    end

    helper :latest_commit_url do
      "https://github.com/#{site.metadata.repo}/commit/#{commit_sha}"
    end

    # Posts that share the most tags with the given post, newest first.
    # Returns [] for non-posts or posts with no overlapping tags so callers can
    # skip rendering rather than padding with unrelated content.
    helper :related_posts do |resource, limit = 4|
      next [] unless resource.respond_to?(:collection) && resource.collection&.label == "posts"

      tags = Array(resource.data.tags)
      next [] if tags.empty?

      site.collections.posts.resources
        .reject { |post| post.relative_url == resource.relative_url }
        .map { |post| [post, (Array(post.data.tags) & tags).size] }
        .select { |(_, shared)| shared.positive? }
        .sort_by { |(post, shared)| [-shared, -post.date.to_i] }
        .first(limit)
        .map(&:first)
    end

    helper :should_show_toc do |resource|
      next false unless resource.collection&.label == "posts"
      next false if resource.data.toc == false
      resource.content.to_s.split.size > 800
    end

    helper :tag_slug do |tag|
      tag.to_s.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-|-+\z/, "")
    end
  end

  private

  # Resolves the commit SHA for the current build from the environment, falling
  # back to local git. Computed once and closed over by the commit helpers.
  # @return [String] the full commit SHA, or "" if it can't be determined
  def resolve_commit_sha
    ENV["CF_PAGES_COMMIT_SHA"] || ENV["GITHUB_SHA"] || `git rev-parse HEAD 2>/dev/null`.strip
  rescue
    ""
  end
end

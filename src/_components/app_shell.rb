# The application shell: a source list beside a pane.
#
# This is the site's one compositional idea. From `shell` (1024px) up, the left
# column is a persistent source list on the chrome ground and the right column
# is a pane on a lighter ground — the arrangement every desktop application the
# audience uses all day already has. Below `shell` the source list folds into a
# bar and its drawer, and the pane becomes the whole page.
#
# The pane owns the one measure on the site, so every view — the homepage, an
# index, an article — shares a left edge and a gutter.
class AppShell < Bridgetown::Component
  # @param resource [Bridgetown::Resource::Base] the current page, for the
  #   source list's you-are-here state
  # @param kind [String, nil] Pagefind metadata for the resource kind
  def initialize(resource: nil, kind: nil)
    @resource = resource
    @kind = kind
  end

  attr_reader :resource, :kind
end

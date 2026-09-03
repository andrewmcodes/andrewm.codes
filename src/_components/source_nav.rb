# The source list's data and its you-are-here rule, shared by the rail and the
# drawer.
#
# A phone does not get a different information architecture — it gets the same
# one in less room — so both surfaces read the same `navigation.yml` and resolve
# "current" the same way. Duplicating this was the first thing that would have
# drifted.
module SourceNav
  def primary = Array(Bridgetown::Current.site.data.navigation.primary)

  def elsewhere = Array(Bridgetown::Current.site.data.navigation.elsewhere)

  # A view owns every URL that belongs to it, not just its own path. Posts live
  # at `/p/:slug/` and tag pages at `/tag/:term/`, CFPs at `/cfps/:slug/` — all
  # of them are somewhere the reader arrived *from* a section, and a rail that
  # goes blank on the page you actually landed on is a rail that stops telling
  # you where you are.
  OWNS = {
    "/" => [],
    "/posts/" => ["/p/", "/posts", "/tag/"],
    "/speaking/" => ["/speaking", "/cfps/"],
    "/projects/" => ["/projects"]
  }.freeze

  def current?(url)
    path = resource&.relative_url.to_s
    return path == "/" if url == "/"

    prefixes = OWNS.fetch(url, [url.to_s.chomp("/")])
    prefixes.any? && path.start_with?(*prefixes)
  end
end

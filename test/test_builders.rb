require "minitest_helper"
require_relative "../plugins/og_helper"

# Bridgetown auto-defines this namespace when it loads plugins/builders/*; we
# create it explicitly for the standalone unit test path so we can require the
# builder file without a full site boot.
module Builders; end
require_relative "../plugins/site_builder"
require_relative "../plugins/builders/search_index"

# Plain Minitest tests for pure builder logic — no Bridgetown::Test, no site
# build. Fast feedback for the regex/string handling that's easy to get wrong.
class TestBuilders < Minitest::Test
  Resource = Struct.new(:relative_url, :relative_path, :data)
  ResourceData = Struct.new(:permalink)

  # -------- OgHelper.slug --------

  def test_og_helper_slug_index_for_root
    resource = Resource.new("/", "src/index.erb", ResourceData.new(permalink: nil))
    assert_equal "index", OgHelper.slug(resource)
  end

  def test_og_helper_slug_strips_date_prefix_from_post_basename
    resource = Resource.new(
      "/p/my-post/",
      "_posts/blog/2024-05-10-my-post.md",
      ResourceData.new(permalink: nil)
    )
    assert_equal "my-post", OgHelper.slug(resource)
  end

  def test_og_helper_slug_uses_basename_without_date
    resource = Resource.new(
      "/about/",
      "_pages/about.md",
      ResourceData.new(permalink: nil)
    )
    assert_equal "about", OgHelper.slug(resource)
  end

  def test_og_helper_slug_flattens_permalink_slashes
    resource = Resource.new(
      "/cfps/perfectionism/",
      "_cfps/perfectionism.md",
      ResourceData.new(permalink: "/cfps/perfectionism/")
    )
    assert_equal "cfps-perfectionism", OgHelper.slug(resource)
  end

  def test_og_helper_slug_handles_unrooted_permalink
    resource = Resource.new(
      "/foo/bar/",
      "_pages/whatever.md",
      ResourceData.new(permalink: "foo/bar")
    )
    assert_equal "foo-bar", OgHelper.slug(resource)
  end

  # -------- Builders::SearchIndex#external_url --------

  def test_search_index_external_url_returns_fallback_for_empty
    assert_equal "/projects/", builder.send(:external_url, "", fallback: "/projects/")
    assert_equal "/projects/", builder.send(:external_url, nil, fallback: "/projects/")
    assert_equal "/projects/", builder.send(:external_url, "#", fallback: "/projects/")
  end

  def test_search_index_external_url_prefixes_https_for_bare_www
    assert_equal(
      "https://www.example.com/talk",
      builder.send(:external_url, "www.example.com/talk", fallback: "/speaking/")
    )
  end

  def test_search_index_external_url_prefixes_https_for_bare_youtube
    assert_equal(
      "https://youtube.com/watch?v=abc",
      builder.send(:external_url, "youtube.com/watch?v=abc", fallback: "/speaking/")
    )
  end

  def test_search_index_external_url_passes_through_http_urls
    assert_equal(
      "https://github.com/andrewmcodes",
      builder.send(:external_url, "https://github.com/andrewmcodes", fallback: "/")
    )
  end

  private

  def builder
    @builder ||= Builders::SearchIndex.allocate
  end
end

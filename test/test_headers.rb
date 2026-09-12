require "minitest_helper"

# Cloudflare _headers is copied from src/_headers into the destination by
# plugins/builders/headers.rb at :site, :post_write (Bridgetown skips
# underscore-prefixed source files, so it needs help reaching output/).

class TestHeaders < Bridgetown::Test
  HEADERS_PATH = File.join(__dir__, "..", "output", "_headers")
  HEADERS = File.read(HEADERS_PATH) if File.exist?(HEADERS_PATH)

  it "is generated into the build output" do
    refute_nil HEADERS, "Expected output/_headers to exist after build"
  end

  it "serves the Atom feed with the correct Content-Type" do
    expect(HEADERS).must_match %r{^/feed\.xml$}
    expect(HEADERS).must_match %r{Content-Type: application/atom\+xml}
  end

  it "serves the JSON feed as application/feed+json" do
    expect(HEADERS).must_match %r{^/feed\.json$}
    expect(HEADERS).must_match %r{Content-Type: application/feed\+json}
  end

  it "sets security headers for all routes" do
    expect(HEADERS).must_match %r{X-Content-Type-Options: nosniff}
    expect(HEADERS).must_match %r{Referrer-Policy: strict-origin-when-cross-origin}
  end

  it "allows search and AI input but not training" do
    expect(HEADERS).must_include "Content-Signal: search=yes, ai-input=yes, ai-train=no"
  end

  it "ships a Content-Security-Policy with a default-src directive" do
    expect(HEADERS).must_match %r{Content-Security-Policy(-Report-Only)?: .*default-src 'self'}
  end

  it "allows the Cloudflare Web Analytics beacon in script-src" do
    expect(HEADERS).must_match %r{script-src [^\n]*https://static\.cloudflareinsights\.com}
  end

  it "caches the persistent shell avatar across reloads" do
    expect(HEADERS).must_include "/images/main-avatar-*\n  Cache-Control: public, max-age=31536000, immutable"
  end

  it "links HTML and Markdown representations in both directions" do
    expect(HEADERS).must_include "/p/*/\n  Link: </p/:splat.md>; rel=\"alternate\"; type=\"text/markdown\""
    expect(HEADERS).must_include "/p/*.md\n  Link: </p/:splat/>; rel=\"alternate\"; type=\"text/html\""
    expect(HEADERS).must_include "/about/\n  Link: </about.md>; rel=\"alternate\"; type=\"text/markdown\""
    expect(HEADERS).must_include "/about.md\n  Link: </about/>; rel=\"alternate\"; type=\"text/html\""
    expect(HEADERS).must_include "/projects/\n  Link: </projects.md>; rel=\"alternate\"; type=\"text/markdown\""
  end
end

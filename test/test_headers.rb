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
    expect(HEADERS).must_match %r{Strict-Transport-Security: max-age=31536000}
  end

  it "ships both enforced and report-only Content-Security-Policy headers" do
    expect(HEADERS).must_match %r{Content-Security-Policy: .*default-src 'self'}
    expect(HEADERS).must_match %r{Content-Security-Policy-Report-Only: .*default-src 'self'}
  end
end

require "minitest_helper"

class TestSitemapAndFeeds < Bridgetown::Test
  describe "/sitemap.xml" do
    before do
      get "/sitemap.xml"
      @body = last_response.body
    end

    it "is served" do
      expect(last_response.status).must_equal 200
    end

    it "includes posts at /p/:slug/" do
      expect(@body).must_match %r{<loc>https://andrewm\.codes/p/}
    end

    it "includes tag pages" do
      expect(@body).must_match %r{<loc>https://andrewm\.codes/tag/}
    end

    it "excludes the 404 page" do
      expect(@body).wont_match %r{/404\.html}
      expect(@body).wont_match %r{<loc>[^<]*/404</loc>}
    end

    it "excludes the JSON and RSS feeds" do
      expect(@body).wont_match %r{/feed\.json}
      expect(@body).wont_match %r{/feed\.xml}
    end
  end

  describe "/feed.xml" do
    it "is served as Atom or RSS feed" do
      get "/feed.xml"
      expect(last_response.status).must_equal 200
      # bridgetown-feed emits Atom XML
      expect(last_response.body).must_match(/<(rss|feed)\b/)
    end
  end

  describe "/feed.json" do
    it "is served as a JSON feed" do
      # Bridgetown::Test's `json` parses the body into `document`, not `response`.
      json get "/feed.json"
      expect(document["version"]).must_match(/jsonfeed\.org/)
      expect(document["items"]).wont_be_empty
    end

    it "lists post URLs at /p/:slug/" do
      json get "/feed.json"
      urls = document["items"].map { |item| item["url"] }
      expect(urls).wont_be_empty
      expect(urls.all? { |u| u.include?("/p/") }).must_equal true
    end

    it "lists posts in the same order as the RSS feed" do
      json get "/feed.json"
      json_urls = document["items"].map { |i| i["url"] }
      get "/feed.xml"
      xml_urls = last_response.body.scan(%r{<link[^>]*href="([^"]+/p/[^"]+)"})
        .flatten
        .reject { |u| u.end_with?("/feed.xml") }
      expect(xml_urls.first(3)).must_equal json_urls.first(3)
    end
  end

  describe "the footer" do
    before { html get "/" }

    it "links to both feeds" do
      hrefs = document.query_selector_all("footer a").map { |a| a["href"] }
      expect(hrefs).must_include "/feed.xml"
      expect(hrefs).must_include "/feed.json"
    end
  end
end

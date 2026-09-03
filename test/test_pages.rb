require "minitest_helper"

# Heading anchors injected by ProseHeadings inspector add a trailing "#" to
# every h2/h3/h4 inside .prose. Strip it when comparing text.
def heading_text(node)
  node.text.strip.sub(/#\z/, "").strip
end

class TestPages < Bridgetown::Test
  describe "/" do
    before { html get "/" }

    it "renders the hero claim with its inline links" do
      links = document.query_selector_all("main a")

      expect(links.any? { |link| link["href"] == "https://podia.com" && link.text.strip == "Podia" }).must_equal true
      expect(links.any? { |link| link["href"] == "https://remoteruby.com/" && link.text.strip == "Remote Ruby" }).must_equal true
    end

    it "makes each section label the way into that section" do
      hrefs = document.query_selector_all("main a").map { |a| a["href"] }

      expect(hrefs).must_include "/posts/"
      expect(hrefs).must_include "/projects/"
      expect(hrefs).must_include "/speaking/"
    end

    it "derives the hero ledger from the collections" do
      ledger = document.query_selector("main section p.font-mono").text

      expect(ledger).must_match(/\d+ posts/)
      expect(ledger).must_match(/\d+ projects/)
    end
  end

  describe "/speaking/" do
    before { html get "/speaking/" }

    it "renders" do
      expect(document.query_selector("h1").text.strip).must_equal "Speaking"
    end

    it "lists Remote Ruby as currently hosted" do
      expect(document.inner_html).must_include "Remote Ruby"
    end

    it "groups previously hosted podcasts separately" do
      headings = document.query_selector_all("h2").map { |h| heading_text(h) }
      expect(headings.any? { |h| h.downcase.include?("currently") }).must_equal true
      expect(headings.any? { |h| h.downcase.include?("previously") }).must_equal true
    end

    it "describes each speaking section" do
      section_descriptions = [
        "Shows I'm actively hosting or involved with",
        "Shows I used to host or appear on regularly",
        "Conference talks and presentations I've given",
        "Conference proposals I've submitted over the years",
        "Guest spots, interviews, and conference appearances"
      ]

      section_descriptions.each do |description|
        expect(document.inner_html).must_include description
      end
    end
  end

  describe "a CFP detail page" do
    before { html get "/cfps/perfectionism-the-death-of-progress/" }

    it "keeps the Speaking view current in the source list" do
      current = document.query_selector("nav[aria-label='Primary'] a[aria-current='page']")

      expect(current).wont_be_nil
      expect(current["href"]).must_equal "/speaking/"
    end
  end

  describe "/uses/" do
    before { html get "/uses/" }

    it "renders" do
      expect(document.query_selector("h1").text.strip).must_equal "Uses"
    end

    it "groups tools under category headings" do
      headings = document.query_selector_all("h2").map { |h| heading_text(h) }
      expect(headings).must_include "Workstation"
    end
  end

  describe "/about/" do
    before { html get "/about/" }

    it "renders" do
      expect(document.query_selector("h1").text.strip).must_equal "About"
    end

    it "links to Remote Ruby" do
      hrefs = document.query_selector_all("a").map { |a| a["href"] }
      expect(hrefs).must_include "https://remoteruby.com"
    end
  end

  describe "/search/" do
    before { html get "/search/" }

    it "renders a search form wired to the client index" do
      expect(document.query_selector("h1").text.strip).must_equal "Search"
      expect(document.query_selector("[data-search-form]")).wont_be_nil
      expect(document.query_selector("#search-input")).wont_be_nil
    end

    it "is noindex (results pages should not be indexed)" do
      robots = document.query_selector("meta[name='robots']")
      expect(robots["content"]).must_match(/noindex/)
    end
  end

  describe "404" do
    before { html get "/404.html" }

    it "renders the not-found heading in words, not a status code" do
      expect(document.query_selector("h1").text.strip).must_equal "Not found"
    end

    it "offers a real way onward rather than a dead end" do
      expect(document.query_selector_all("a[href^='/p/']").size).must_equal 5
    end

    it "is marked noindex" do
      robots = document.query_selector("meta[name='robots']")
      expect(robots).wont_be_nil
      expect(robots["content"]).must_match(/noindex/)
    end
  end
end

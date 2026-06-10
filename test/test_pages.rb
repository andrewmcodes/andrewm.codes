require "minitest_helper"

# Heading anchors injected by ProseHeadings inspector add a trailing "#" to
# every h2/h3/h4 inside .prose. Strip it when comparing text.
def heading_text(node)
  node.text.strip.sub(/#\z/, "").strip
end

class TestPages < Bridgetown::Test
  describe "/" do
    before { html get "/" }

    it "renders homepage inline links with labels" do
      links = document.query_selector_all("main a")

      expect(links.any? { |link| link["href"] == "https://podia.com" && link.text.strip == "Podia" }).must_equal true
      expect(links.any? { |link| link["href"] == "/speaking/" && link.text.strip == "Remote Ruby" }).must_equal true
      expect(links.any? { |link| link["href"] == "/projects/" && link.text.strip == "open source" }).must_equal true
      expect(links.any? { |link| link["href"] == "/speaking/" && link.text.strip == "talks and podcasts" }).must_equal true
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

    it "keeps the Speaking nav item active" do
      speaking_link = document.query_selector("header a[href='/speaking/']")

      expect(speaking_link["class"]).must_include "text-sage-12"
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

    it "renders the not-found heading" do
      expect(document.query_selector("h1").text.strip).must_equal "404"
    end

    it "is marked noindex" do
      robots = document.query_selector("meta[name='robots']")
      expect(robots).wont_be_nil
      expect(robots["content"]).must_match(/noindex/)
    end
  end
end

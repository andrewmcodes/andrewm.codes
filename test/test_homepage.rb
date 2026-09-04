require "minitest_helper"

class TestHomepage < Bridgetown::Test
  describe "/" do
    before { html get "/" }

    it "renders the hero with the author name" do
      h1 = document.query_selector("h1")
      expect(h1.text.strip).must_include "Andrew Mason"
    end

    it "links to /posts/" do
      hrefs = document.query_selector_all("a").map { |a| a["href"] }
      expect(hrefs).must_include "/posts/"
    end

    it "renders the source list with the lockup and the primary views" do
      nav = document.query_selector("nav[aria-label='Primary']").inner_html
      expect(nav).must_include "Andrew Mason"
      expect(nav).must_include "Writing"
      expect(nav).must_include "Projects"
    end

    it "marks the current view in the source list" do
      current = document.query_selector("nav[aria-label='Primary'] a[aria-current='page']")
      expect(current).wont_be_nil
      expect(current["href"]).must_equal "/"
    end

    it "sets section labels in sentence case, like the nav" do
      labels = document.query_selector_all("main section > div > div > a, main section > div > div > h2")
        .map { |n| n.text.strip.split("\n").first.to_s.strip }
        .reject(&:empty?)

      expect(labels).wont_be_empty
      expect(labels.reject { |l| l[0] == l[0].upcase }).must_equal []
    end

    it "includes seo meta tags" do
      expect(document.query_selector("meta[property='og:title']")).wont_be_nil
      expect(document.query_selector("link[rel='canonical']")).wont_be_nil
    end

    it "includes Atom + JSON feed alternates" do
      types = document.query_selector_all("link[rel='alternate']").map { |l| l["type"] }
      expect(types).must_include "application/atom+xml"
      expect(types).must_include "application/feed+json"
    end

    it "includes a skip-to-content link before the topbar" do
      first_focusable = document.query_selector("body a")
      expect(first_focusable.text.strip).must_equal "Skip to content"
      expect(first_focusable["href"]).must_equal "#main"
    end

    it "has main element with id=main for the skip link target" do
      expect(document.query_selector("main#main")).wont_be_nil
    end
  end
end

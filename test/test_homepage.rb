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

    it "renders the topbar with brand and nav" do
      expect(document.query_selector("header").inner_html).must_include "Andrew Mason"
      expect(document.query_selector("nav").inner_html).must_include "Posts"
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

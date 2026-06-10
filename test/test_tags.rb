require "minitest_helper"

class TestTags < Bridgetown::Test
  describe "tag prototype pages" do
    it "exist at /tag/<slug>/ for tags used by posts" do
      html get "/tag/rails/"
      expect(document.query_selector("h1").text.strip).must_include "rails"
    end

    it "lists matching posts only" do
      html get "/tag/rails/"
      row_links = document.query_selector_all("[data-post-row]").map { |a| a["href"] }
      expect(row_links).wont_be_empty
      expect(row_links.all? { |h| h.start_with?("/p/") }).must_equal true
    end

    it "has a back link to /posts/" do
      html get "/tag/rails/"
      back = document.query_selector_all("a").find { |a| a.text.include?("all posts") }
      expect(back).wont_be_nil
      expect(back["href"]).must_equal "/posts/"
    end

    it "has a per-tag og:image so each tag gets a unique social card" do
      html get "/tag/rails/"
      og = document.query_selector("meta[property='og:image']")["content"]
      expect(og).must_match %r{/og/tag-rails\.png\z}
      expect(og).wont_match %r{/og/default\.png\z}
    end
  end
end

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

    it "keeps substantial tag pages indexable" do
      html get "/tag/rails/"
      robots = document.query_selector("meta[name='robots']")
      canonical = document.query_selector("link[rel='canonical']")

      expect(robots["content"]).wont_match(/noindex/)
      expect(canonical["href"]).must_equal "https://andrewm.codes/tag/rails/"
    end

    it "noindexes thin tag pages but still lets crawlers follow through" do
      html get "/tag/unix/"
      robots = document.query_selector("meta[name='robots']")

      expect(robots["content"]).must_match(/noindex/)
      expect(robots["content"]).wont_match(/nofollow/)
      expect(document.query_selector("link[rel='canonical']")).must_be_nil
    end

    it "describes each tag by post count and date range" do
      html get "/tag/rails/"
      description = document.query_selector("meta[name='description']")["content"]

      expect(description).must_match(/\A\d+ posts tagged #rails, published /)
      expect(description.length).must_be :>=, 70
    end

    # Bridgetown's prototype generator force-enables pagination, and tag.erb
    # renders the full list itself — so every /tag/<term>/page/N/ was an
    # orphaned, indexable byte-copy of page 1.
    it "emits no paginated duplicates" do
      destination = File.expand_path("../output", __dir__)
      paginated = Dir.glob(File.join(destination, "tag", "*", "page", "*", "index.html"))

      expect(paginated).must_equal []
    end
  end
end

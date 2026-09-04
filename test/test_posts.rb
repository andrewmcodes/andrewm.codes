require "minitest_helper"

class TestPosts < Bridgetown::Test
  describe "/posts/" do
    before { html get "/posts/" }

    it "renders the page heading" do
      expect(document.query_selector("h1").text.strip).must_equal "Writing"
    end

    it "shows year-grouped post rows" do
      rows = document.query_selector_all("[data-post-row]")
      expect(rows.size).must_be :>, 5
    end

    it "renders tag filter links to prototype tag pages" do
      tag_links = document.query_selector_all("a[href^='/tag/']")
      expect(tag_links.size).must_be :>, 0
    end

    it "uses the new /p/:slug permalink for post links" do
      post_links = document.query_selector_all("[data-post-row]")
      expect(post_links).wont_be_empty
      hrefs = post_links.map { |a| a["href"] }
      expect(hrefs.all? { |h| h.start_with?("/p/") }).must_equal true
    end
  end

  describe "a single post" do
    before { html get "/p/twitter-avatar/" }

    it "renders the post title" do
      expect(document.query_selector("h1").text.strip).must_include "Twitter Avatar"
    end

    it "shows reading time in the meta row" do
      # First mb-10 div = meta row (after the back link)
      expect(document.inner_html).must_include "min read"
    end

    it "renders prev/next nav in the footer" do
      footer_links = document.query_selector_all("footer a").map { |a| a["href"] }
      expect(footer_links.any? { |h| h && h.start_with?("/p/") }).must_equal true
    end

    it "exposes tag links to prototype tag pages" do
      tag_links = document.query_selector_all("a[href^='/tag/']")
      expect(tag_links).wont_be_empty
    end

    it "shows the stale-content alert when the post is >2 years old" do
      note = document.query_selector("aside[role='note']")
      expect(note).wont_be_nil
      expect(note.text).must_include "Last updated"
      expect(note.query_selector("time")).wont_be_nil
    end

    it "credits Andrew Mason with a byline linking to /about/" do
      byline = document.query_selector("a[rel='author']")
      expect(byline).wont_be_nil
      expect(byline["href"]).must_equal "/about/"
      expect(byline.text.strip).must_equal "Andrew Mason"
    end

    it "always syndicates to the RSS feed" do
      section = document.query_selector("section[aria-labelledby='webmentions-heading']")
      expect(section).wont_be_nil
      expect(section.text).must_include "syndicated to"
      hrefs = section.query_selector_all("a").map { |a| a["href"] }
      expect(hrefs).must_include "https://andrewm.codes/feed.xml"
    end

    it "offers a webmention endpoint form targeting this post's absolute URL" do
      form = document.query_selector("section[aria-labelledby='webmentions-heading'] form")
      expect(form).wont_be_nil
      expect(form["action"]).must_equal "https://webmention.io/andrewm.codes/webmention"
      target = form.query_selector("input[name='target']")
      expect(target["value"]).must_equal "https://andrewm.codes/p/twitter-avatar/"
    end
  end

  describe "a post with content images" do
    before { html get "/p/a11y-in-rails-automated-linting-with-accesslint/" }

    it "async-decodes every image and lazy-loads all but the first" do
      imgs = document.query_selector_all("img")
      expect(imgs.size).must_be :>, 1
      expect(imgs.all? { |i| i["decoding"] == "async" }).must_equal true
      # First image stays eager (likely LCP); the rest are lazy.
      expect(imgs.first["loading"]).must_be_nil
      expect(imgs[1]["loading"]).must_equal "lazy"
      expect(imgs.last["loading"]).must_equal "lazy"
    end
  end

  describe "a post with tag-sharing siblings" do
    before { html get "/p/ci-for-ruby-on-rails-circleci/" }

    it "surfaces related posts as crawlable internal links" do
      related = document.query_selector("nav[aria-label='Related posts']")
      expect(related).wont_be_nil
      links = related.query_selector_all("a").map { |a| a["href"] }
      expect(links).wont_be_empty
      expect(links.size).must_be :<=, 4
      expect(links.all? { |h| h.start_with?("/p/") }).must_equal true
      expect(links).wont_include "/p/ci-for-ruby-on-rails-circleci/"
    end
  end
end

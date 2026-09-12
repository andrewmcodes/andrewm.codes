require "minitest_helper"

class TestDesignReview < Bridgetown::Test
  describe "design review regressions" do
    it "renders a named changelog source link and consistent release headings" do
      html get "/changelog/"
      link = document.query_selector("main a[href$='/CHANGELOG.md']")
      expect(link.text.strip).must_equal "CHANGELOG.md"
      expect(document.query_selector("main").text).must_include "Sourced from"
      releases = document.query_selector_all(".prose h2, .prose h3")
        .select { |heading| heading.text.match?(/\A\s*\d+\.\d+\.\d+/) }
      expect(releases).wont_be_empty
      releases.each { |heading| expect(heading.name).must_equal "h2" }
      expect(releases.first.text).must_match(/\A\s*\d+\.\d+\.\d+\s+.+\s+\d{4}-\d{2}-\d{2}/)
    end

    it "keeps the complete projects archive available before filtering" do
      html get "/projects/"
      items = document.query_selector_all("[data-archive-item]")
      expect(items.size).must_equal JSON.parse(File.read("src/_data/oss.json")).size
      expect(items.any? { |item| item.key?("hidden") }).must_equal false
      controls = document.query_selector("[data-archive-controls]")
      expect(controls.key?("hidden")).must_equal false
      expect(controls.key?("disabled")).must_equal true
      expect(document.query_selector("[data-archive-status]").text.strip).must_equal "#{items.size} of #{items.size} projects"
      grid = document.query_selector(".card-grid")
      expect(grid["class"]).must_include "grid-cols-1"
      expect(grid["class"]).must_include "min-[680px]:grid-cols-2"
    end

    it "provides search recovery destinations without JavaScript" do
      html get "/search/"
      suggestions = document.query_selector("[data-search-suggestions]")
      expect(suggestions.text).must_include "Recent writing"
      expect(suggestions.query_selector_all("a").size).must_be :>, 3
    end
  end
end

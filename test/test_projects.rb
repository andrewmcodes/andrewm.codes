require "minitest_helper"

class TestProjects < Bridgetown::Test
  describe "/projects/" do
    before { html get "/projects/" }

    it "renders the page heading" do
      expect(document.query_selector("h1").text.strip).must_equal "Projects"
    end

    it "renders project rows" do
      rows = document.query_selector_all("main a[target='_blank']")
      expect(rows.size).must_be :>, 0
    end

    it "links every project row directly to GitHub with target=_blank" do
      rows = document.query_selector_all("main a[target='_blank']")
      hrefs = rows.map { |a| a["href"] }
      expect(hrefs).wont_be_empty
      expect(hrefs.all? { |h| h.to_s.include?("github.com") }).must_equal true
    end
  end
end

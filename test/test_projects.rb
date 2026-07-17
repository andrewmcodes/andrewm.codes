require "minitest_helper"

class TestProjects < Bridgetown::Test
  describe "/projects/" do
    before { html get "/projects/" }

    it "renders the page heading" do
      expect(document.query_selector("h1").text.strip).must_equal "Projects"
    end

    it "renders project cards" do
      cards = document.query_selector_all(".card-grid > a")
      expect(cards.size).must_be :>, 0
    end

    it "links every card directly to GitHub with target=_blank" do
      cards = document.query_selector_all(".card-grid > a")
      hrefs = cards.map { |a| a["href"] }
      expect(hrefs).wont_be_empty
      expect(hrefs.all? { |h| h.to_s.include?("github.com") }).must_equal true
      expect(cards.all? { |a| a["target"] == "_blank" }).must_equal true
    end
  end
end

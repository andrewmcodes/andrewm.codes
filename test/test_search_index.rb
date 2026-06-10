require "minitest_helper"

class TestSearchIndex < Bridgetown::Test
  describe "/search.json" do
    before do
      json get "/search.json"
      @entries = document
    end

    it "indexes the content advertised by the command palette" do
      kinds = @entries.map { |entry| entry["kind"] }

      expect(kinds).must_include "post"
      expect(kinds).must_include "project"
      expect(kinds).must_include "talk"
      expect(kinds).must_include "podcast"
      expect(kinds).must_include "episode"
    end

    it "links project entries to their project URLs" do
      project = @entries.find { |entry| entry["kind"] == "project" }

      expect(project["url"]).must_match %r{\Ahttps://github\.com/}
    end
  end
end

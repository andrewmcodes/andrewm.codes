require "minitest_helper"
require "nokolexbor"

class TestSeo < Bridgetown::Test
  describe "rendered SEO metadata" do
    it "keeps titles, descriptions, and h1s within expected bounds" do
      failures = []
      destination = File.expand_path("../output", __dir__)

      # /stories/* are dev-only component fragments (bare HTML, no <head>) that
      # Builders::Stories strips from production output, so they're exempt from
      # page-level SEO assertions.
      Dir.glob(File.join(destination, "**/*.html")).sort.each do |file|
        next if file.delete_prefix("#{destination}/").start_with?("stories/")

        doc = Nokolexbor::HTML(File.read(file))
        title = doc.css("title").first&.text.to_s.gsub(/\s+/, " ").strip
        description = doc.css("meta[name='description']").first&.[]("content").to_s
        h1_count = doc.css("h1").size
        path = file.delete_prefix("#{destination}/")

        failures << "#{path}: expected exactly one h1, found #{h1_count}" unless h1_count == 1
        failures << "#{path}: title length #{title.length}" unless title.length.between?(10, 60)
        failures << "#{path}: description length #{description.length}" unless description.length.between?(50, 160)
      end

      expect(failures).must_equal []
    end
  end
end

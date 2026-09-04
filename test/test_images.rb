require "minitest_helper"

ENDPOINT = "https://ik.imagekit.io/z7cjas4rs".freeze

class TestImages < Bridgetown::Test
  describe "post images" do
    it "serves content images from the configured ImageKit endpoint" do
      html get "/p/rails-coverage-tools-codefactor/"
      sources = document.query_selector_all("img").map { |img| img["src"] }
      remote = sources.reject { |src| src.start_with?("/") }

      expect(remote).wont_be_empty
      expect(remote.all? { |src| src.start_with?(ENDPOINT) }).must_equal true
    end

    it "caps wide images with the medium preset and leaves narrow ones alone" do
      html get "/p/automating-ruby-gem-releases-with-github-actions/"
      sources = document.query_selector_all("img").map { |img| img["src"] }

      # 1145px wide — worth capping to the prose column.
      wide = sources.find { |src| src.include?("new-github-release.png") }
      # 475px wide — asking ImageKit for w-800 would upscale it.
      narrow = sources.find { |src| src.include?("release-action-success.png") }

      expect(wide).must_include "?tr=w-800"
      expect(narrow).wont_be_nil
      expect(narrow).wont_include "tr="
    end

    it "renders the Image component's iid through the same helper" do
      html get "/p/twitter-avatar/"
      figure = document.query_selector_all("img").find { |img| img["src"].to_s.include?("blackmagic") }

      expect(figure).wont_be_nil
      expect(figure["src"]).must_include "#{ENDPOINT}/posts/twitter-avatar/"
    end

    # The migration's whole point: no post should depend on an image host we no
    # longer control. Both of these were also outside the img-src CSP allowlist.
    it "references no Cloudinary or dev.to images anywhere in the build" do
      destination = File.expand_path("../output", __dir__)
      offenders = Dir.glob(File.join(destination, "**/*.html")).select do |file|
        File.read(file).match?(/res\.cloudinary\.com|dev-to-uploads\.s3\.amazonaws\.com/)
      end

      expect(offenders.map { |f| f.delete_prefix("#{destination}/") }).must_equal []
    end
  end
end

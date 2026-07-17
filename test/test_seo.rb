require "minitest_helper"
require "json"
require "nokolexbor"
require "uri"

SITE_HOST = "andrewm.codes".freeze
ALLOWED_NOINDEX_PATHS = [
  %r{\A/404\.html\z},
  %r{\A/search/\z},
  %r{\A/tag/[^/]+/\z}
].freeze

def rendered_path(file, destination)
  path = file.delete_prefix("#{destination}/")
  return "/" if path == "index.html"
  return "/#{path.delete_suffix("index.html")}" if path.end_with?("/index.html")

  "/#{path}"
end

def robots_content(doc)
  doc.css("meta[name='robots']").first&.[]("content").to_s
end

def noindex?(doc)
  robots_content(doc).match?(/\bnoindex\b/i)
end

def allowed_noindex_path?(path)
  ALLOWED_NOINDEX_PATHS.any? { |pattern| path.match?(pattern) }
end

def meta_content(doc, selector)
  doc.css(selector).first&.[]("content").to_s.strip
end

def local_path(url)
  uri = URI.parse(url)
  return nil unless uri.host == SITE_HOST

  path = uri.path.empty? ? "/" : uri.path
  uri.query ? "#{path}?#{uri.query}" : path
rescue URI::InvalidURIError
  nil
end

def valid_absolute_url?(url)
  uri = URI.parse(url)
  %w[http https].include?(uri.scheme) && uri.host.to_s != ""
rescue URI::InvalidURIError
  false
end

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
        path = rendered_path(file, destination)
        titles = doc.css("title")
        title = doc.css("title").first&.text.to_s.gsub(/\s+/, " ").strip
        description = doc.css("meta[name='description']").first&.[]("content").to_s
        h1_count = doc.css("h1").size

        failures << "#{path}: expected exactly one title, found #{titles.size}" unless titles.size == 1
        failures << "#{path}: expected exactly one h1, found #{h1_count}" unless h1_count == 1
        failures << "#{path}: title length #{title.length}" unless title.length.between?(10, 60)
        failures << "#{path}: description length #{description.length}" unless description.length.between?(50, 160)
      end

      expect(failures).must_equal []
    end

    it "validates indexable page metadata relationships" do
      failures = []
      destination = File.expand_path("../output", __dir__)
      source = File.expand_path("../src", __dir__)

      Dir.glob(File.join(destination, "**/*.html")).sort.each do |file|
        next if file.delete_prefix("#{destination}/").start_with?("stories/")

        doc = Nokolexbor::HTML(File.read(file))
        path = rendered_path(file, destination)

        if noindex?(doc)
          failures << "#{path}: unexpected noindex" unless allowed_noindex_path?(path)
          failures << "#{path}: noindex page should not emit canonical" unless doc.css("link[rel='canonical']").empty?
          next
        end

        canonicals = doc.css("link[rel='canonical']")
        canonical = canonicals.first&.[]("href").to_s.strip
        og_url = meta_content(doc, "meta[property='og:url']")
        og_image = meta_content(doc, "meta[property='og:image']")

        failures << "#{path}: expected exactly one canonical, found #{canonicals.size}" unless canonicals.size == 1
        failures << "#{path}: canonical is not an absolute URL" unless valid_absolute_url?(canonical)
        failures << "#{path}: og:url does not match canonical" unless og_url == canonical
        failures << "#{path}: og:image is not an absolute URL" unless valid_absolute_url?(og_image)

        if (canonical_path = local_path(canonical))
          get canonical_path
          failures << "#{path}: canonical #{canonical_path} returned #{last_response.status}" unless last_response.status == 200
        end

        if (image_path = local_path(og_image))
          local_image = image_path.delete_prefix("/")
          image_exists = File.exist?(File.join(destination, local_image)) || File.exist?(File.join(source, local_image))
          generated_og_image = image_path.match?(%r{\A/og/[^/]+\.png\z})
          failures << "#{path}: local og:image #{image_path} does not exist" unless image_exists || generated_og_image
        end

        doc.css("script[type='application/ld+json']").each_with_index do |script, index|
          schema = JSON.parse(script.inner_html.strip.gsub('<\/', "</"))
          failures << "#{path}: JSON-LD #{index + 1} missing schema.org context" unless schema["@context"] == "https://schema.org"
        rescue JSON::ParserError => e
          failures << "#{path}: invalid JSON-LD #{index + 1}: #{e.message}"
        end
      end

      expect(failures).must_equal []
    end
  end
end

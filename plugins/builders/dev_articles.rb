require "pathname"
require "json"

class LoadPostsFromJson < SiteBuilder
  def build
    JSON
      .parse(File.read(data_file_path))
      .each do |data|
        next unless data["published_at"]
        doc "#{Bridgetown::Utils.slugify(data["title"])}.md" do
          front_matter data
          slug "#{Bridgetown::Utils.slugify(data["title"])}"
          categories "blog"
          tags data["tag_list"]
          date Bridgetown::Utils.parse_date(data["published_at"])
          content data["body_markdown"].gsub(/<%/, "<%%")
          layout "post"
        end
      end
  end

  private

  def data_file_path
    File.expand_path("../../../src/_data/dev_to_articles.json", Pathname.new(__FILE__).realpath)
  end
end

require_relative "base"

class Page < Base
  def write_pages
    JSON
      .parse(File.read(data_file_path))
      .each do |page|
        slug = Bridgetown::Utils.slugify(page["title"])
        page_path = File.expand_path("../../src/_pages/#{slug}.md", Pathname.new(__FILE__).realpath)
        File.write(page_path, html(page, slug))
      end
  end

  def html(item, slug)
    <<~HTML
      ---
      id: #{item["id"]}
      title: "#{item["title"]}"
      slug: /#{slug}/
      description: "#{item["description"]}"
      published_at: "#{parse_date(item["published_at"])}"
      created_at: "#{parse_date(item["created_at"])}"
      updated_at: "#{parse_date(item["updated_at"])}"
      ---
      #{item["content"]}
    HTML
  end

  def parse_date(date)
    Bridgetown::Utils.parse_date(date || Date.today)
  end
end

c = Page.new("pages")
c.dump(c.all.to_s)
c.write_pages

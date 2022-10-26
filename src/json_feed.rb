###ruby
front_matter do
  layout nil
  permalink "/feed.json"
end
###

{
  version: "https://jsonfeed.org/version/1",
  title: site.metadata.title,
  icon: absolute_url("/public/favicon.png"),
  home_page_url: absolute_url("/"),
  feed_url: absolute_url("feed.json"),
  items:
    site
      .collections
      .posts
      .resources
      .map do |post|
        {
          id: post.absolute_url,
          title: post.data.title,
          content_html: post.content,
          date_published: post.data.date,
          url: post.absolute_url
        }
      end
}.to_json

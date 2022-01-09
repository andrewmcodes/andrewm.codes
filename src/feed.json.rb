###ruby
front_matter do
  layout nil
  permalink "/feed.json"
end
###

{
  version: "https://jsonfeed.org/version/1",
  title: site.metadata.title,
  icon: absolute_url("/icon-192.png"),
  home_page_url: absolute_url("/"),
  feed_url: absolute_url("feed.json"),
  items:
    site
      .collections
      .posts
      .resources
      .map do |post|
        {
          id: absolute_url(post.relative_url),
          title: post.data.title,
          content_html: post.content,
          date_published: post.data.date,
          url: absolute_url(post.relative_url)
        }
      end
}.to_json

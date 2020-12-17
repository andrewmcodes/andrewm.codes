# class Devto < SiteBuilder
#   def build
#     hook :site, :post_read do
#       site.data[:dev_to].each do |post|
#         doc "articles/#{post.slug}.md" do
#           collection "posts"
#           layout "posts"
#           title post.title
#           description post.description
#           date post.published_at
#           slug post.slug
#           dev_to_url post.url
#           canonical_url post.canonical_url
#           cover_image post.cover_image
#           tags post.tags
#           categories ["article"]
#           content post.body_text
#         end
#       end
#     end
#   end
# end

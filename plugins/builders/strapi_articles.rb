# class StrapiArticles < SiteBuilder
#   graphql :articles do
#     query do
#       articles(sort: "updated_at") do
#         id
#         created_at
#         updated_at
#         title
#         description
#         dev_to_url
#         content
#         published_at
#       end
#     end
#   end

#   def build
#     build_articles
#   end

#   def build_articles
#     queries.articles.each do |article|
#       slug = Bridgetown::Utils.slugify(article.title)
#       doc "#{slug}.md" do
#         title article.title
#         description article.description
#         frontmatter article.to_h.reject { |key, value| key.start_with?("content") }
#         layout "post"
#         categories ["blog"]
#         created_at Bridgetown::Utils.parse_date(article.created_at || Date.today)
#         updated_at Bridgetown::Utils.parse_date(article.updated_at || Date.today)
#         published_at (Bridgetown::Utils.parse_date(article.published_at) if article.published_at)
#         content article.content.gsub(/<%=/, "<%%=")
#       end
#     end
#   end
# end

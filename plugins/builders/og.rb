class Builders::Og < SiteBuilder
  def build
    if Bridgetown.env.production?
      hook :posts, :pre_render do |post|
        post.data.image ||= create_og_image(post.data.title)
      end
    end
  end

  def create_og_image(title)
    "https://og.andrewmcodes.dev/api/page?title=#{CGI.escape(title)}"
  end
end

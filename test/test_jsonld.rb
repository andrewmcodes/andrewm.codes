require "minitest_helper"
require "json"

def jsonld_scripts(doc)
  doc.query_selector_all("script[type='application/ld+json']").map { |s|
    JSON.parse(s.inner_html.strip.gsub('<\/', "</"))
  }
end

def jsonld_of_type(doc, type)
  jsonld_scripts(doc).select { |s| s["@type"] == type }
end

PERSON_ID = "https://andrewm.codes/#person".freeze

class TestJsonLd < Bridgetown::Test
  describe "/" do
    before { html get "/" }

    it "emits WebSite and Person" do
      types = jsonld_scripts(document).map { |s| s["@type"] }
      expect(types).must_include "WebSite"
      expect(types).must_include "Person"
    end

    it "uses one canonical Person @id" do
      person = jsonld_of_type(document, "Person").find { |p| p["name"] }
      expect(person["@id"]).must_equal PERSON_ID
      expect(person["url"]).must_equal "https://andrewm.codes/about/"
    end

    it "lists social profiles in Person.sameAs" do
      person = jsonld_of_type(document, "Person").find { |p| p["sameAs"] }
      expect(person["sameAs"]).must_include "https://bsky.app/profile/andrewm.codes"
      expect(person["sameAs"]).must_include "https://github.com/andrewmcodes"
      expect(person["sameAs"]).must_include "https://www.linkedin.com/in/andrew-mason"
    end

    it "points WebSite.publisher at the Person @id" do
      website = jsonld_of_type(document, "WebSite").first
      expect(website["publisher"]["@id"]).must_equal PERSON_ID
    end

    it "exposes a SearchAction for the sitelinks search box" do
      website = jsonld_of_type(document, "WebSite").first
      action = website["potentialAction"]
      expect(action["@type"]).must_equal "SearchAction"
      expect(action["target"]["urlTemplate"]).must_equal "https://andrewm.codes/search/?q={search_term_string}"
    end

    it "lists topical expertise in Person.knowsAbout" do
      person = jsonld_of_type(document, "Person").find { |p| p["knowsAbout"] }
      expect(person["knowsAbout"]).must_include "Ruby on Rails"
    end
  end

  describe "/about/" do
    before { html get "/about/" }

    it "emits ProfilePage whose mainEntity is the Person" do
      profile = jsonld_of_type(document, "ProfilePage").first
      expect(profile).wont_be_nil
      expect(profile["mainEntity"]["@type"]).must_equal "Person"
      expect(profile["mainEntity"]["name"]).must_equal "Andrew Mason"
      expect(profile["mainEntity"]["@id"]).must_equal PERSON_ID
    end
  end

  describe "/posts/" do
    before { html get "/posts/" }

    it "emits Blog with recent blogPosts" do
      blog = jsonld_of_type(document, "Blog").first
      expect(blog).wont_be_nil
      expect(blog["blogPost"]).wont_be_empty
      expect(blog["blogPost"].first["url"]).must_match(%r{/p/})
    end
  end

  describe "/projects/" do
    before { html get "/projects/" }

    it "emits CollectionPage with an ItemList of projects" do
      page = jsonld_of_type(document, "CollectionPage").first
      expect(page).wont_be_nil
      items = page["mainEntity"]["itemListElement"]
      expect(items).wont_be_empty
      expect(items.first["@type"]).must_equal "ListItem"
      expect(items.first["position"]).must_equal 1
    end
  end

  describe "a tag page" do
    before { html get "/tag/rails/" }

    it "emits CollectionPage with tagged posts" do
      page = jsonld_of_type(document, "CollectionPage").first
      expect(page).wont_be_nil
      expect(page["name"]).must_match(/rails/)
      expect(page["mainEntity"]["itemListElement"]).wont_be_empty
    end

    it "emits a BreadcrumbList ending on the tag" do
      crumbs = jsonld_of_type(document, "BreadcrumbList").first
      expect(crumbs).wont_be_nil
      names = crumbs["itemListElement"].map { |i| i["name"] }
      expect(names.first).must_equal "Home"
      expect(names.last).must_equal "#rails"
    end
  end

  describe "a single post" do
    before { html get "/p/twitter-avatar/" }

    it "emits a complete BlogPosting" do
      post = jsonld_of_type(document, "BlogPosting").first
      expect(post).wont_be_nil
      expect(post["headline"]).must_match(/Twitter Avatar/i)
      expect(post["description"]).wont_be_empty
      expect(post["datePublished"]).wont_be_nil
      expect(post["keywords"]).must_include "twitter"
      expect(post["inLanguage"]).must_equal "en"
      expect(post["wordCount"]).must_be :>, 0
    end

    it "always has a dateModified (falls back to publish date)" do
      post = jsonld_of_type(document, "BlogPosting").first
      expect(post["dateModified"]).wont_be_nil
      expect(post["dateModified"]).must_match(/\A\d{4}-\d{2}-\d{2}/)
    end

    it "attributes authorship to Andrew Mason at /about/" do
      post = jsonld_of_type(document, "BlogPosting").first
      expect(post["author"]["name"]).must_equal "Andrew Mason"
      expect(post["author"]["url"]).must_equal "https://andrewm.codes/about/"
      expect(post["author"]["@id"]).must_equal PERSON_ID
    end

    it "emits a BreadcrumbList Home / Posts / title" do
      crumbs = jsonld_of_type(document, "BreadcrumbList").first
      expect(crumbs).wont_be_nil
      names = crumbs["itemListElement"].map { |i| i["name"] }
      expect(names.first).must_equal "Home"
      expect(names[1]).must_equal "Posts"
      expect(crumbs["itemListElement"].last["item"]).must_equal "https://andrewm.codes/p/twitter-avatar/"
    end
  end

  describe "/speaking/" do
    before { html get "/speaking/" }

    it "emits a VideoObject per recorded talk" do
      videos = jsonld_of_type(document, "VideoObject")
      expect(videos).wont_be_empty
      expect(videos.first["uploadDate"]).wont_be_nil
      expect(videos.first["contentUrl"]).wont_be_nil
    end

    it "emits PodcastSeries for hosted shows" do
      series = jsonld_of_type(document, "PodcastSeries")
      names = series.map { |s| s["name"] }
      expect(names).must_include "Remote Ruby"
    end

    it "emits the latest PodcastEpisode tied to its series" do
      episode = jsonld_of_type(document, "PodcastEpisode").first
      expect(episode).wont_be_nil
      expect(episode["episodeNumber"]).must_be :>, 0
      expect(episode["duration"]).must_match(/\APT/)
      expect(episode["partOfSeries"]["name"]).must_equal "Remote Ruby"
    end
  end

  describe "a CFP page" do
    before { html get "/cfps/perfectionism-the-death-of-progress/" }

    it "emits an Article authored by the same Person" do
      article = jsonld_of_type(document, "Article").first
      expect(article).wont_be_nil
      expect(article["author"]["@id"]).must_equal PERSON_ID
      expect(article["datePublished"]).wont_be_nil
    end

    it "emits a BreadcrumbList under Speaking" do
      crumbs = jsonld_of_type(document, "BreadcrumbList").first
      names = crumbs["itemListElement"].map { |i| i["name"] }
      expect(names).must_include "Speaking"
    end
  end
end

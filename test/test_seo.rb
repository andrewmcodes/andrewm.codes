require_relative "./helper"

class TestSeo < Minitest::Test
  context "when homepage" do
    setup do
      page = site.collections.pages.resources.find { |doc| doc.relative_url == "/" }
      document_root page
    end

    should "have basic tags" do
      assert_select "meta[charset='#{site.metadata.charset}']", count: 1
      assert_select "meta[name='viewport'][content='#{site.metadata.viewport}']", count: 1
      assert_select "title", count: 1
      assert_select "meta[name='description'][content='#{site.metadata.description}']", count: 1
      assert_select "meta[property='author'][content='#{site.metadata.author.name}']", count: 1
      assert_select "meta[property='generator'][content='#{site.metadata.generator}']", count: 1
    end

    should "have OG tags" do
      assert_select "meta[property='og:title']", count: 1
      assert_select "meta[property='og:description'][content='#{site.metadata.description}']", count: 1
      assert_select "meta[property='og:image']", count: 1
      assert_select "meta[property='og:url']", count: 1
      assert_select "meta[property='og:site_name']", count: 1
      assert_select "meta[property='og:type']", count: 1
    end

    should "have Twitter tags" do
      assert_select "meta[name='twitter:card']", count: 1
      assert_select "meta[name='twitter:site'][content='@andrewmcodes']", count: 1
      assert_select "meta[name='twitter:creator'][content='@andrewmcodes']", count: 1
      assert_select "meta[name='twitter:title']", count: 1
      assert_select "meta[name='twitter:description'][content='#{site.metadata.description}']", count: 1
      assert_select "meta[name='twitter:image']", count: 1
    end

    should "have color tags" do
      assert_select "meta[name='theme-color'][media='(prefers-color-scheme: light)'][content='#{site.metadata.theme_color.light}']"
      assert_select "meta[name='theme-color'][media='(prefers-color-scheme: dark)'][content='#{site.metadata.theme_color.dark}']"
    end

    should "have links" do
      assert_select "link[rel='canonical']", count: 1
      assert_select "link[rel='webmention'][href='https://webmention.io/andrewm.codes/webmention']", count: 1
      assert_select "link[rel='pingback'][href='https://webmention.io/andrewm.codes/xmlrpc']", count: 1
      assert_select "link[rel='me'][href='https://twitter.com/andrewmcodes']", count: 1
      assert_select "link[rel='me'][href='https://github.com/andrewmcodes']", count: 1
      assert_select "link[rel='me'][href='https://andrewm.codes']", count: 1
    end

    should "have feed links" do
      assert_select "link[rel='alternate'][type='application/atom+xml']", count: 1
      assert_select "link[rel='alternate'][type='application/json']", count: 1
    end
  end
end

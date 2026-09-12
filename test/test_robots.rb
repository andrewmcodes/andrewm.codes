require "minitest/autorun"

class TestRobots < Minitest::Test
  ROBOTS = File.read(File.join(__dir__, "..", "src", "robots.txt"))

  def test_allows_all_pages
    assert_includes ROBOTS, "User-agent: *"
    assert_includes ROBOTS, "Allow: /"
  end

  def test_includes_sitemap
    assert_includes ROBOTS, "Sitemap: https://andrewm.codes/sitemap.xml"
  end
end

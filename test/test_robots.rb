require "minitest/autorun"

class TestRobots < Minitest::Test
  ROBOTS = File.read(File.join(__dir__, "..", "src", "robots.txt"))

  def test_allows_search_and_ai_input_but_not_training
    assert_includes ROBOTS, "User-agent: *"
    assert_includes ROBOTS, "Content-Signal: search=yes, ai-input=yes, ai-train=no"
    assert_includes ROBOTS, "Allow: /"
    assert_includes ROBOTS, "Sitemap: https://andrewm.codes/sitemap.xml"
  end
end

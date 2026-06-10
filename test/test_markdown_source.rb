require "minitest_helper"

# plugins/builders/markdown_source.rb writes Markdown twins + llms.txt /
# llms-full.txt at :site, :post_write. These read the generated files from the
# build destination (same approach as test_redirects.rb) and assert the
# on-page "Copy page" control renders.

class TestMarkdownSource < Bridgetown::Test
  OUTPUT = File.join(__dir__, "..", "output")

  def self.read_output(*path)
    file = File.join(OUTPUT, *path)
    File.read(file) if File.exist?(file)
  end

  KILL_MD = read_output("p", "kill-process-on-port.md")
  LLMS = read_output("llms.txt")
  LLMS_FULL = read_output("llms-full.txt")

  it "writes a .md twin for each post" do
    refute_nil KILL_MD, "Expected output/p/kill-process-on-port.md to exist after build"
    expect(KILL_MD).must_match(/\A# Kill Process Running on a Specific Port/)
    expect(KILL_MD).must_include "```sh"
    expect(KILL_MD).must_include "lsof -ti tcp:4000"
  end

  it "writes an llms.txt index linking to the .md twins" do
    refute_nil LLMS, "Expected output/llms.txt to exist after build"
    expect(LLMS).must_match(/^# andrewm\.codes/)
    expect(LLMS).must_include "## Posts"
    expect(LLMS).must_include "https://andrewm.codes/p/kill-process-on-port.md"
  end

  it "writes a concatenated llms-full.txt" do
    refute_nil LLMS_FULL, "Expected output/llms-full.txt to exist after build"
    expect(LLMS_FULL).must_include "# Kill Process Running on a Specific Port"
    expect(LLMS_FULL).must_match(/\n---\n/)
  end

  describe "the Copy page control" do
    before { html get "/p/kill-process-on-port/" }

    it "renders the Markdown actions toolbar pointing at the .md twin" do
      actions = document.query_selector(".md-actions")
      expect(actions).wont_be_nil
      expect(actions["data-md-url"]).must_equal "/p/kill-process-on-port.md"
    end

    it "offers View as Markdown plus assistant deep links" do
      hrefs = document.query_selector_all(".md-actions a").map { |a| a["href"] }
      expect(hrefs).must_include "/p/kill-process-on-port.md"
      expect(hrefs.any? { |h| h.start_with?("https://claude.ai/new?q=") }).must_equal true
      expect(hrefs.any? { |h| h.start_with?("https://chatgpt.com/?q=") }).must_equal true
    end
  end
end

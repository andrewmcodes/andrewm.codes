require "minitest_helper"
require "json"
require "open3"

class TestSvgs < Minitest::Test
  ROOT = File.expand_path("..", __dir__)
  CONFIG = File.join(ROOT, "svgo.config.mjs")
  SVGS = Dir.glob(File.join(ROOT, "src/images/*.svg")).sort.freeze

  def test_svgo_config_preserves_viewbox_while_minifying_svg
    sample = <<~SVG
      <?xml version="1.0" encoding="UTF-8"?>
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
        <!-- trim me -->
        <path d="M 0 0 L 24 24" />
      </svg>
    SVG

    optimized = optimize(sample, path: "sample.svg")

    assert_includes optimized, 'viewBox="0 0 24 24"'
    refute_includes optimized, "<!-- trim me -->"
    refute_includes optimized, "<?xml"
  end

  def test_tracked_svgs_are_already_minified
    assert_operator SVGS.size, :>, 0

    offenders = SVGS.filter_map do |path|
      current = File.read(path)
      relative = path.delete_prefix("#{ROOT}/")
      relative if optimize(current, path: relative) != current
    end

    assert_equal [], offenders
  end

  private

  def optimize(svg, path:)
    script = <<~JS
      import { optimize } from "svgo"
      import config from "./svgo.config.mjs"

      const input = process.argv[1]
      const path = process.argv[2]
      const result = optimize(input, { ...config, multipass: true, path })
      process.stdout.write(JSON.stringify(result.data))
    JS

    stdout, stderr, status = Dir.chdir(ROOT) do
      Open3.capture3("node", "--input-type=module", "-e", script, svg, path)
    end

    assert status.success?, stderr
    JSON.parse(stdout)
  end
end

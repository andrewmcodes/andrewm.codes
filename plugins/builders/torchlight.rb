class Builders::Torchlight < SiteBuilder
  def build
    hook :site, :post_write, priority: :high do
      # Only run in production builds — Torchlight hits the API and saves to
      # output HTML files. Dev/test builds skip it (code blocks render plain).
      next unless Bridgetown.env.production?

      if ENV["TORCHLIGHT_TOKEN"].to_s.strip.empty?
        Bridgetown.logger.warn "Torchlight:", "TORCHLIGHT_TOKEN is unset — skipping syntax highlighting."
        next
      end

      Bridgetown.logger.info "Torchlight:", "Highlighting code blocks..."
      # `-i output` pins the input directory; without it torchlight defaults
      # to CWD and walks .bundle/, src/, tmp/, etc.
      # `-c` passes our CommonJS config explicitly — the CLI's auto-discover
      # doesn't find .cjs files when package.json is "type": "module".
      raise "Torchlight highlight failed" unless system(
        "pnpm", "exec", "torchlight", "highlight",
        "-c", "torchlight.config.cjs",
        "-i", "output"
      )
    end
  end
end

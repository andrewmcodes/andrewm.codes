// Lighthouse CI config. `.cjs` (not `.js`) because package.json sets
// "type": "module" and LHCI loads this with require().
//
// Runs against the already-built static output (./output), so CI can reuse the
// `site-output` artifact from the production build job rather than rebuilding.
// Performance is a soft warning; accessibility and SEO are enforced as errors.
//
// `numberOfRuns: 1` — this job is informational (it does not gate the deploy)
// and a11y/SEO scores are deterministic on static HTML, so the median-of-3
// smoothing isn't worth 3x the Chrome runtime. CI further shards this URL list
// across concurrent `lhci autorun` steps (see .github/workflows/ci.yml); keep
// the two lists in sync.
module.exports = {
  ci: {
    collect: {
      staticDistDir: "./output",
      numberOfRuns: 1,
      url: [
        "http://localhost/",
        "http://localhost/posts/",
        "http://localhost/about/",
        "http://localhost/projects/",
        "http://localhost/speaking/",
        "http://localhost/p/kill-process-on-port/",
        "http://localhost/tag/rails/",
      ],
    },
    assert: {
      assertions: {
        "categories:seo": ["error", { minScore: 1 }],
        "categories:performance": ["warn", { minScore: 0.87 }],
        "categories:accessibility": ["error", { minScore: 0.9 }],
      },
    },
    upload: {
      target: "temporary-public-storage",
    },
  },
};

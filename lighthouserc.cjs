// Lighthouse CI config. `.cjs` (not `.js`) because package.json sets
// "type": "module" and LHCI loads this with require().
//
// Runs against the already-built static output (./output), so CI can reuse the
// `site-output` artifact from the production build job rather than rebuilding.
// Enforce minimum quality bars on key page types and fail CI regressions.
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
        "categories:performance": ["error", { minScore: 0.9 }],
        "categories:accessibility": ["error", { minScore: 0.9 }],
        "largest-contentful-paint": ["error", { maxNumericValue: 2500 }],
        "cumulative-layout-shift": ["error", { maxNumericValue: 0.1 }],
        "interaction-to-next-paint": ["error", { maxNumericValue: 200 }],
      },
    },
    upload: {
      target: "temporary-public-storage",
    },
  },
};

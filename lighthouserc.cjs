// Lighthouse CI config. `.cjs` (not `.js`) because package.json sets
// "type": "module" and LHCI loads this with require().
//
// Runs against the already-built static output (./output), so CI can reuse the
// `site-output` artifact from the production build job rather than rebuilding.
// Performance is a soft warning; accessibility is enforced as an error.
module.exports = {
  ci: {
    collect: {
      staticDistDir: "./output",
      numberOfRuns: 1,
    },
    assert: {
      assertions: {
        "categories:performance": ["warn", { minScore: 0.87 }],
        "categories:accessibility": ["error", { minScore: 0.88 }],
      },
    },
    upload: {
      target: "temporary-public-storage",
    },
  },
};

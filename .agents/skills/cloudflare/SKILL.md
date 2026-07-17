---
name: cloudflare
description: Cloudflare skill scoped to how andrewm.codes actually uses the platform — a static Bridgetown build served by Workers Static Assets, deployed with Wrangler, with Workers observability enabled. Covers Static Assets, Workers, Wrangler, and Observability. Biases towards retrieval from Cloudflare docs over pre-trained knowledge.
references:
  - static-assets
  - workers
  - wrangler
  - observability
---

# Cloudflare Platform Skill

Scoped to how this project uses Cloudflare. andrewm.codes is a fully static Bridgetown build (`output/`) served by **Workers Static Assets** and deployed with **Wrangler**. There is no SSR, no database, and no bindings — production is static files plus Workers observability. See `wrangler.jsonc` for the deploy config and the project `CLAUDE.md` for the deploy/CI details.

Your knowledge of Cloudflare APIs, types, limits, and pricing may be outdated. **Prefer retrieval over pre-training** — the references in this skill are starting points, not source of truth.

## Retrieval Sources

Fetch the **latest** information before citing specific numbers, API signatures, or configuration options. Do not rely on baked-in knowledge or these reference files alone.

| Source | How to retrieve | Use for |
| --- | --- | --- |
| Cloudflare docs | `cloudflare-docs` search tool or `https://developers.cloudflare.com/` | Limits, pricing, API reference, compatibility dates/flags |
| Workers types | `npm pack @cloudflare/workers-types` or check `node_modules` | Type signatures, binding shapes, handler types |
| Wrangler config schema | `node_modules/wrangler/config-schema.json` | Config fields, binding shapes, allowed values |
| Product changelogs | `https://developers.cloudflare.com/changelog/` | Recent changes to limits, features, deprecations |

When a reference file and the docs disagree, **trust the docs**. This is especially important for: numeric limits, pricing tiers, type signatures, and configuration options.

## This Project's Cloudflare Setup

- **Serving** — the production build in `output/` is uploaded as Workers Static Assets (`assets.directory` in `wrangler.jsonc`). `not_found_handling: "404-page"` serves `/404.html` on misses; a Cloudflare-format `_redirects` file (written by `plugins/builders/redirects.rb`) handles legacy and per-post redirects. There is intentionally no `/*` catch-all.
- **Deploy** — via `cloudflare/wrangler-action@v4`. Push to `main` → `wrangler deploy`; same-repo PR → `wrangler versions upload --preview-alias <slug>`. Fork PRs skip deploy.
- **Observability** — enabled in `wrangler.jsonc` (`observability.logs`), so Workers Logs are available for the static-asset Worker.

## Reference Index

| Topic | Reference | Use for |
| --- | --- | --- |
| Static Assets | `references/static-assets/` | `assets` config, `not_found_handling`, `_redirects`, routing precedence |
| Workers | `references/workers/` | Worker runtime model, request handling, compatibility dates/flags |
| Wrangler | `references/wrangler/` | `deploy`, `versions upload`, config schema, preview aliases |
| Observability | `references/observability/` | Workers Logs, sampling, trace/log config, real-time debugging |

If a task genuinely needs a Cloudflare product not listed here (a database, queue, AI, etc.), that would be a new capability for this site — retrieve from the Cloudflare docs rather than assuming it's already wired up, and consider whether it belongs in this static-site architecture at all.

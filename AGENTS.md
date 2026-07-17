# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Stack

Bridgetown 2.2+ (ERB + ViewComponent), Ruby 4.0.3, Node 22, pnpm. Tailwind v4 + Radix UI Colors (Sage + Mint). Rouge for syntax highlighting. Cloudflare Workers Static Assets deploy (see `wrangler.jsonc`). Tooling versions and tasks are owned by `mise.toml`; secrets are managed by `fnox` with the macOS Keychain provider — `fnox.toml` (plaintext, committed) declares which env vars to populate and references Keychain entries under the `fnox-andrewmcodes-v8` service; values themselves never live in git.

## Commands

Use `mise run <task>` — these are the canonical entry points:

- `mise run setup` — first-time setup: installs tools (via `mise install`), gems, and pnpm deps.
- `mise run dev` — start the Bridgetown dev server (`bin/bridgetown start`). Dev intentionally skips OG image generation (OG `<meta>` tags emit predicted `/og/<slug>.png` paths but the PNG files only exist after a production build, so OG previews look broken in dev until `mise run build` is run at least once).
- `mise run build` — production build wrapped in `fnox exec` to load configured secrets. Equivalent to `BRIDGETOWN_ENV=production bin/bridgetown deploy`.
- `mise run test` — `bundle exec rake test` (Minitest + `bridgetown/test`). Tests build the site in `BRIDGETOWN_ENV=test` and assert against rendered HTML via `Bridgetown::Test`.
- `mise run format` — `bundle exec standardrb --fix && pnpm run format` (Prettier for JS/YAML/MD).
- `mise run og` — regenerate OG images locally via `node scripts/generate-og.mjs`.

Run a single test file: `bundle exec rake test TEST=test/test_homepage.rb`. Run a single test by name: `bundle exec ruby -Itest test/test_homepage.rb -n /links to/`.

Lint only: `bundle exec standardrb` (CI uses this without `--fix`).

## Architecture

### Resource pipeline

`bridgetown.config.yml` defines three collections, each with its own URL shape:

- **posts** → `/p/:slug/` (note: not `/:slug/` — see Redirects below).
- **pages** → `/:slug/`.
- **projects** → `/projects/:path.*/`.

Layouts default by collection (`post`, `page`, `page` respectively). `config/initializers.rb` sets `template_engine "erb"` site-wide and enables `dotenv`, `bridgetown-feed`, `bridgetown-sitemap`, `bridgetown-svg-inliner`, and pagination. SEO metadata is emitted by the in-repo `Util::Seo` component (`src/_components/util/seo.rb`), not by `bridgetown-seo-tag`.

### Builders (`plugins/builders/`)

All inherit from `SiteBuilder` (which inherits from `Bridgetown::Builder`). They hook into the build lifecycle to extend resources and post-process output:

- **`helpers.rb`** — registers ERB helpers via `helper :name do ... end`. Notable: `build_title`, `github_edit_url`, `latest_commit_sha`/`latest_commit_url` (prefers `CF_PAGES_COMMIT_SHA`), `should_show_toc` (only for posts >800 words and not opted out via front matter `toc: false`). The `cx` class-concat helper lives on `Base` (`src/_components/base.rb`).
- **`reading_time.rb`** — adds `resource.reading_time` via `define_resource_method`. 220 WPM, min 1.
- **`og_images.rb`** — `resources:post_read` hook assigns `resource.data.image = "/og/<slug>.png"` for posts/projects/pages/cfps (skipping prototype pages and any with `image:` already set). In production only, a `site:post_write` hook (priority `:low`) shells out to `scripts/generate-og.mjs`, which parses every `output/**/*.html`, extracts `og:title`/`og:description`/`og:image`, and writes PNGs to `output/og/<slug>.png` via Satori + Resvg. Generator reads **rendered HTML** (per PRD), so any computed title or `seo_title` override flows through.
- **`redirects.rb`** — writes a Cloudflare-format `_redirects` file at `site:post_write` (consumed by Workers Static Assets `not_found_handling`). Includes static legacy redirects (v7 URLs, `/blog/*` and `/snippets/*` → `/p/*`) and enumerated per-post redirects from `/:slug/` → `/p/:slug/`. **There is intentionally no `/*` catch-all** — `wrangler.jsonc`'s `not_found_handling: "404-page"` serves `/404.html` on misses, and a catch-all here would match `/` and cause a redirect loop. **If you add a post, the per-slug redirect is generated automatically.**
- **`inspectors/links.rb`** — `inspect_html` (prod only) adds `target="_blank" rel="noreferrer"` to external links and ensures any pre-existing `target="_blank"` gets `rel="noreferrer"`.
- **`inspectors/prose_headings.rb`** — heading anchor IDs / TOC linking.
- **`tailwind_jit.rb`** / **`cloudinary.rb`** — JIT / image helpers.

When adding a new builder, place it in `plugins/builders/` and inherit `SiteBuilder` — it will be auto-loaded.

### Components (`src/_components/`)

ViewComponent-style — each component has a `.rb` (logic) and optionally an `.erb` (template). Render with `<%= render ComponentName.new(...) %>`.

Many components inherit from `Base` (`src/_components/base.rb`), which provides:

- Shared design-token maps: `TEXT_SIZES`, `TEXT_WEIGHT`, `TEXT_SCHEME`, `HEADING_SIZES`, `HEADING_SCHEME`, `FONT_FAMILY`. **Use these maps for new typographic components rather than re-hardcoding sage/mint utility classes.**
- `helper_opts` / `tag_opts` / `classes` pattern: pass arbitrary HTML attributes through `**opts`, override `tag_opts` to inject element-specific attrs, override `classes` to provide default Tailwind classes. `INVALID_ATTRIBUTES` (`:as`, `:classes`, `:class_name`) are stripped from the spread.
- `cx(...)` concatenator and `slugify(str)` helper.

### Posts and content

- `src/_posts/_defaults.yml` sets `layout: post_layout` and a `back:` breadcrumb. Subdirectories like `src/_posts/blog/` and `src/_posts/snippets/` have their own `_defaults.yml` that can override.
- Post URLs live under `/p/:slug/`. The old root-level URL for each post (`/:slug/`) is auto-redirected to `/p/:slug/` by `Builders::Redirects`. **Do not add new pages with slugs that collide with existing post slugs** — they'd be shadowed by the redirect.
- Site data lives in `src/_data/` (YAML/JSON): `site_metadata.yml`, `navigation.yml`, `accounts.json`, `appearances.json`, `talks.yml`, `podcasts.yml`. Access via `site.metadata.*` and `site.data.*` in templates.

### Frontend assets

`frontend/javascript/index.js` is the entry point; bundled with esbuild via `config/esbuild.defaults.js`. CSS lives in `frontend/styles/index.css` (Tailwind v4 + PostCSS). The Rake `frontend:build` task (chained from `:deploy`) runs `npm run esbuild`.

Theme detection is inlined in `src/_layouts/default.erb` and runs synchronously before paint, setting `data-theme` from `localStorage` or `prefers-color-scheme`.

### Server / Roda

`server/roda_app.rb` mounts `bridgetown_server` and `r.bridgetown` — this is only used by the dev server. Production is a fully static build uploaded to Cloudflare Workers Static Assets; **don't add SSR routes in `server/routes` expecting them to work in prod** unless you also wire up a non-static deploy target.

## Environment & secrets

- `BRIDGETOWN_ENV=production` toggles OG image generation and the link inspector. Tests use `BRIDGETOWN_ENV=test`.
- Two-machine setup: `fnox.toml` only carries Keychain entry _names_, so on a new Mac re-add each value with `fnox set <NAME>` (writes to the macOS Keychain under the `fnox-andrewmcodes-v8` service). Nothing to copy between machines.

## CI / Deploy

`.github/workflows/ci.yml` runs four jobs on push/PR: `standardrb` lint, `bundle exec rake test`, a full production build (exercises OG generation), and a deploy job gated on the other three. The site is deployed to **Cloudflare Workers Static Assets** (see `wrangler.jsonc`) via `cloudflare/wrangler-action@v4`:

- Push to `main` → `wrangler deploy` to production.
- PR from a same-repo branch → `wrangler versions upload --preview-alias <slug>`, then `gh pr comment` posts the preview URL. Branch slug is built as `pr-<num>-<head-ref>` lowercased, non-alphanumerics → `-`, capped at 40 chars.
- Fork PRs skip the deploy job (no secret access); lint/test/build still run.

Required GitHub repo secrets: `CLOUDFLARE_API_TOKEN` (Workers Scripts: Edit permission), `CLOUDFLARE_ACCOUNT_ID`.

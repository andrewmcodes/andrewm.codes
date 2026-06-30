---
name: bridgetown
description: Use whenever the user is building, modifying, debugging, or asking about a Bridgetown site or any of its features — ERB layouts, ViewComponent, collections, resources, front matter, pagination, prototype pages, plugins/builders, hooks, helpers, inspectors (`inspect_html`), wikilinks, external content sources, SSR routes via Roda, Islands architecture, Declarative Shadow DOM, esbuild bundling, Tailwind setup, or deploying to Vercel/Netlify/Render/Fly. Also trigger when the user says things like "create a new Bridgetown site", "add a Bridgetown plugin", "convert this to Bridgetown", "rebuild andrewm.codes / andrewmcodes-v7", or mentions Bridgetown-specific idioms — `bin/bridgetown`, `site.collections`, `collections.posts.resources`, `Bridgetown::Component`, `SiteBuilder`, `Bridgetown.configure`, `bridgetown.config.yml`, `config/initializers.rb`, `init :wikilinks`, `paginator.resources`, `helper :name`, `define_resource_method`, `inspect_html`, `render_with`, `<is-land>`, or `template_engine "erb"`. Even when "Bridgetown" isn't said explicitly, trigger if the user is clearly working in a Bridgetown project (editing `src/_posts/`, `src/_components/`, `src/_layouts/`, `plugins/builders/`, `frontend/`, or `config/initializers.rb`). When in doubt, consult this skill — under-triggering wastes the curated reference; over-triggering is cheap.
---

# Bridgetown

A condensed local reference library for building Bridgetown sites with Ruby + ERB lives at:

```
/Users/andrew.mason/git/andrewmcodes/sites/bridgetown-reference/
```

40 files covering Bridgetown 2.2+, organized for AI agents.

## How to use this skill

The skill itself is intentionally thin — the real content is in the reference folder. Your job is to:

1. **Read `bridgetown-reference/README.md` first.** It's a navigable index organized by feature area (Setup, Core concepts, Content, Templates, Extending, SSR, Production, Recipes). Use it to find which files are relevant to the current task.
2. **Read specific files on demand.** Don't bulk-load all 40 files; the README has one-line summaries so you can pick precisely. Most tasks only need 2–4 files.
3. **Prefer the reference over web search.** Files are already condensed for AI consumption; web search will reintroduce noise and possibly stale info from older Bridgetown versions.

## Conventions baked into the reference

Follow these unless the user says otherwise — the reference assumes them throughout:

- **Bridgetown 2.2+, Ruby 3.3+, Node 22+** baseline
- **ERB** as template engine (`template_engine "erb"` in `config/initializers.rb`)
- **ViewComponent** (via `bridgetown-view-component`) as the preferred component approach
- **Falcon** as the default Roda web server (2.2+)
- **No Liquid examples** — Ruby helpers, ERB partials, ViewComponent throughout
- **npm**, not Yarn (default since 2.0); **esbuild**, not Webpack (removed in 2.0)

## Quick map: where to look first

If you're not sure which file to open:

| Task | First file to read |
|---|---|
| New site from scratch | `quickstart.md` (copy-pasteable starter) |
| Site config / initializers | `configuration.md` |
| Posts, pages, custom collections | `resources.md`, `collections.md`, `front-matter.md` |
| Pagination / archives | `pagination.md`, `prototype-pages.md` |
| Layouts and components | `layouts.md`, `view-component.md` |
| Built-in template helpers | `helpers.md` |
| Custom Ruby logic / plugins | `plugins.md` |
| HTML/XML post-processing | `inspectors.md` |
| Tailwind / esbuild / frontend | `frontend-assets.md` |
| Dynamic routes / API endpoints | `routes.md`, `roda.md` |
| Hydrated JS islands | `islands.md`, `dsd.md` |
| Wiki / digital garden setup | `external-sources.md`, `resources.md#wikilinks-bridgetown-22` |
| Deploy targets | `deployment.md` |
| Migrating an older Bridgetown site | `upgrade.md` |
| Common recipes (helpers, archives, reading time, related posts) | `cookbook.md` |
| Picking a third-party gem | `community-plugins.md` |

## When the reference disagrees with older code in the repo

The user has two pre-existing Bridgetown 1.2 sites (`andrewm.codes`, `andrewmcodes-v7`) at `/Users/andrew.mason/git/andrewmcodes/sites/`. Patterns from those sites that the reference doesn't show are likely legacy — prefer the reference's modern idioms (e.g., `helper :name` in a SiteBuilder over `Bridgetown::RubyTemplateView::Helpers.include`; ERB over Liquid; npm over Yarn; Falcon over Puma). When unsure, check `upgrade.md` for the migration notes.

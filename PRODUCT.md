# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Four real audiences, all served by the same site, in rough order of how much the design owes them:

1. **Hiring managers and recruiters** — arriving from a resume link, referral, or a name search, deciding in well under a minute whether Andrew is worth a conversation. They skim the first viewport, want depth signals fast, and rarely read a full post.
2. **Ruby/Rails developers arriving from search** — landed on a specific post because they hit a specific problem (CI, ViewComponent, Bridgetown, Rails tooling, Obsidian). They want the answer; staying is a bonus.
3. **Community and podcast listeners** — Remote Ruby listeners, conference attendees, CFP organizers. They already know the name and are looking for talks, episodes, or a way to reach him.
4. **Future Andrew** — the site doubles as a personal archive of things he wants to find again later. This is a real, stated purpose, not a joke in the copy.

No audience is a fallback for the others; the homepage carries the evaluation load, posts carry the search load.

## Product Purpose

The personal site of Andrew Mason — writing, open source, talks, and podcasts in one place. It exists to (a) let a stranger form an accurate and favorable read of his engineering depth without a call, (b) make the writing findable and genuinely useful to people who searched for a problem, and (c) stay cheap enough to maintain that he keeps publishing to it.

Success, confirmed:

- **Credibility at a glance.** The first viewport does persuasion work that would otherwise happen in an interview.
- **Posts get read and found.** Search traffic lands, the post answers the question.
- **It stays maintained.** Low publishing friction matters more than any single feature. A design that raises the cost of writing has failed even if it looks better.

Explicitly _not_ a stated success metric: inbound contact volume. Contact paths must exist and work, but the site is not optimized to generate messages.

## Positioning

A working engineer's site, not a personal brand site. What a neighboring site cannot truthfully copy: roughly a decade of Rails in production, a long-running seat on Remote Ruby (350+ episodes, co-hosted with Chris Oliver, Jason Charnes, and David Hill), conference talks, and a public trail of small tools built to scratch real itches. The credibility comes from accumulation and specificity, not from claims.

## Operating Context

- Visitors arrive from three distinct doors: a resume/referral link to the homepage, a Google result deep-linked into `/p/:slug/`, and podcast or conference mentions of the name.
- Content is authored as Markdown in `src/_posts/` with front matter; publishing is a git commit. Anything that makes that loop heavier works against a confirmed success criterion.
- Collections in use: 46 post files in `src/_posts/` (45 published), 15 projects, 3 CFPs, plus 3 talks, 4 podcasts, 14 appearances, and 4 featured items as YAML/JSON data in `src/_data/`. Counts move; anything the design displays is derived at build time rather than typed in, so these are a description of the repo, not a source the site reads.
- Deployed static to Cloudflare Workers Static Assets; every push to `main` ships.

## Capabilities and Constraints

- Bridgetown 2.2 (ERB + Bridgetown::Component), Ruby 4.0.3, Node 22, pnpm. Tailwind v4 + Radix UI Colors. Torchlight for syntax highlighting. Pagefind for search.
- Fully static output — no server-side rendering in production. `server/roda_app.rb` is dev-only; do not design features that need a request-time backend.
- Post URLs are `/p/:slug/`, pages `/:slug/`, projects `/projects/:path/`. Legacy root-level post URLs are auto-redirected by `plugins/builders/redirects.rb`.
- OG images are generated at production build time from rendered HTML (`scripts/generate-og.mjs`); they do not exist in dev.
- Torchlight, OG generation, and the external-link inspector run only when `BRIDGETOWN_ENV=production`.
- **Dark-first.** Both themes ship and both must be legible, but dark is the ground the site is composed and reviewed in; light is a competent, tested secondary rather than an equal peer. `data-theme` is still resolved before paint in `src/_layouts/default.erb`, and the OS preference is still respected — dark-first is where design attention goes, not an override of the visitor's setting. Reconfirmed at the 2026 redesign against the alternatives of dark-only and light-first.
- **Protected surfaces — confirmed must-keeps.** Two things a redesign may rearrange but may not drop, so future work does not have to re-ask:
  - The **⌘K command palette**, with its keyboard behaviour, backed by Pagefind.
  - The **post apparatus**: publication date, reading time, tags, table of contents, the stale-post notice, and related posts. Where these live is a design decision; whether they exist is not. Everything else is negotiable — at the 2026 redesign Andrew explicitly put every other visual and component decision on the table, holding only URLs, content, and factual copy fixed.
- **Shell shape — confirmed.** A persistent source-list sidebar at desktop widths, collapsing to a bar and drawer on tablet and phone. Chosen over both a sidebar at every width and a centred column at every width.

## Brand Commitments

- **Name and identity:** Andrew Mason, `andrewm.codes`. Handle `andrewmcodes`.
- **Voice — binding.** Personal, lowercase, understated. Section headings are lowercase fragments (`now`, `featured work`, `recent posts`). Self-deprecating asides are part of the voice ("mostly so I can find them again later"). No marketing-speak, no growth-page energy, no exclamation-point enthusiasm. Future copy may be rewritten, but not out of this register.
- **URL structure and redirects — binding.** `/p/:slug/` post URLs and the generated legacy redirects must survive any redesign. Inbound links and search equity depend on them; content reorganization that changes URLs is not a free move.
- Contact is via Bluesky (`bsky.app/profile/andrewm.codes`). Email links were deliberately removed from the site.
- **Convention over conceit — binding.** Offered a dealt visual direction, a pick, and a challenger against the category standard, Andrew chose the standard played straight: the familiar arrangement for an engineer's site, executed at a craft level the category rarely reaches. Craft shows in focus states, keyboard behaviour, motion timing, and state transitions, not in layout invention. Future design work inherits this preference; a novel governing conceit needs a fresh decision, not an assumption.
- **The named craft bar — binding.** **brianlovin.com leads**: it is the reference Andrew names first, and the direction the site was rebuilt toward. rauno.me, paco.me and emilkowal.ski stand behind it as the surrounding quality standard. The bar is a level of finish, not a layout to copy — what these sites share is that the restraint is deliberate and every state is deliberate with it.
- **Rows for chronology, grids for peers — binding.** Dated content (posts, talks, episodes) is a row; genuinely parallel items with no meaningful order (projects, featured work) tile. A grid never carries dated content. **Reaffirmed after a redesign removed every grid and turned projects and featured work into rows: that was a regression, and the tile grid is to be restored on `/projects/` and on the homepage's featured work.** Grids are not merely permitted where a grid is honest — where a set of items genuinely has no order, the grid is the correct primitive and a row list understates it.
- **Component architecture — binding.** Layout components own every unit of whitespace; content components own none. A `Text`, a `Heading`, a row or a tile never sets its own margin — it is placed inside a `Stack` or an `Inline`, and that container decides how far it sits from its neighbour. Sizes are named type roles, tones are semantic names, and space is a named scale; none of the three is ever a raw value at a call site. Adapted from Seek's Braid Design System, which Andrew named as the architecture reference. This survives a visual redesign: the palette and the type may be replaced, this division of labour may not.

## Evidence on Hand

Real, verifiable, already in the repo:

- 46 posts (`src/_posts/`, 45 published), 15 open-source projects (`src/_projects/`), 3 CFP writeups (`src/_cfps/`).
- 3 talks with venues, dates, and video/slide links (`src/_data/talks.yml`) — RailsConf 2022, BridgetownConf 2022, Blastoff Rails 2026.
- Podcast history (`src/_data/podcasts.yml`, `appearances.json`): 4 shows — Remote Ruby (current), previously Ruby for All, The Ruby Blend, Ruby Rogues — plus 14 guest appearances. Every show in the data carries real artwork.
- Curated proof points in `src/_data/featured.yml` — Podia, Remote Ruby, js-configs, obsidian-objects.
- Employment: Ruby on Rails engineer at Podia. Based in Phoenix, Arizona. Grew up in North Carolina, studied Computer Science.

**Must not be fabricated:** there are no testimonials, no client logos, no traffic or performance metrics, no revenue or user numbers, no awards. Do not invent them, and do not imply them through design placeholders. The 350+ Remote Ruby episode count and the "about a decade" of Rails are the only quantities currently claimed; both are real and should be kept accurate rather than inflated.

**Numbers are derived, never typed.** Any count the design displays — posts, projects, talks, stars, forks — is computed from the collections or the data at build time. The one constant is Remote Ruby's back catalogue, stated conservatively as `350+` because `remote_ruby.json` carries only the latest episode. A count that can go stale silently is worse than no count.

Note: the user did not pin the existing bio _wording_ as fixed — copy may be rewritten. The underlying facts above must stay true.

## Product Principles

1. **The first viewport is the resume.** A hiring manager who reads nothing else should come away with an accurate, favorable, specific read. Depth signals over adjectives.
2. **Deep links are front doors.** Most readers never see the homepage. A post page has to stand alone: orient the stranger, prove the author, offer the next thing.
3. **Publishing friction is a design bug.** Any change that makes writing a post harder is a regression, regardless of how it looks.
4. **Accumulation is the argument.** Specific artifacts — posts, talks, tools, episodes — carry the credibility. Design frames them; it never substitutes claims for them.
5. **Understated over emphatic.** The voice earns trust by not selling. Confidence reads as restraint here.

## Accessibility & Inclusion

No product-specific standard was established beyond ordinary good practice. Both themes are first-class and must both be legible; contrast, focus visibility, and keyboard navigation are expected to hold in each.

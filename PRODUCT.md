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
- Collections in use: 55 posts, 15 projects, plus talks, podcasts, appearances, and CFPs as YAML/JSON data in `src/_data/`.
- Deployed static to Cloudflare Workers Static Assets; every push to `main` ships.

## Capabilities and Constraints

- Bridgetown 2.2 (ERB + Bridgetown::Component), Ruby 4.0.3, Node 22, pnpm. Tailwind v4 + Radix UI Colors. Torchlight for syntax highlighting. Pagefind for search.
- Fully static output — no server-side rendering in production. `server/roda_app.rb` is dev-only; do not design features that need a request-time backend.
- Post URLs are `/p/:slug/`, pages `/:slug/`, projects `/projects/:path/`. Legacy root-level post URLs are auto-redirected by `plugins/builders/redirects.rb`.
- OG images are generated at production build time from rendered HTML (`scripts/generate-og.mjs`); they do not exist in dev.
- Torchlight, OG generation, and the external-link inspector run only when `BRIDGETOWN_ENV=production`.
- Dark and light themes are both first-class; `data-theme` is set before paint in `src/_layouts/default.erb`.

## Brand Commitments

- **Name and identity:** Andrew Mason, `andrewm.codes`. Handle `andrewmcodes`.
- **Voice — binding.** Personal, lowercase, understated. Section headings are lowercase fragments (`now`, `featured work`, `recent posts`). Self-deprecating asides are part of the voice ("mostly so I can find them again later"). No marketing-speak, no growth-page energy, no exclamation-point enthusiasm. Future copy may be rewritten, but not out of this register.
- **URL structure and redirects — binding.** `/p/:slug/` post URLs and the generated legacy redirects must survive any redesign. Inbound links and search equity depend on them; content reorganization that changes URLs is not a free move.
- Contact is via Bluesky (`bsky.app/profile/andrewm.codes`). Email links were deliberately removed from the site.

## Evidence on Hand

Real, verifiable, already in the repo:

- 55 posts (`src/_posts/`), 15 open-source projects (`src/_projects/`).
- Talks with venues, dates, and video/slide links (`src/_data/talks.yml`) — RailsConf 2022, BridgetownConf 2022, Blastoff Rails 2026, among others.
- Podcast history (`src/_data/podcasts.yml`, `appearances.json`): Remote Ruby (current), previously Ruby for All, The Ruby Blend, Ruby Rogues, plus guest appearances.
- Curated proof points in `src/_data/featured.yml` — Podia, Remote Ruby, js-configs, obsidian-objects.
- Employment: Ruby on Rails engineer at Podia. Based in Phoenix, Arizona. Grew up in North Carolina, studied Computer Science.

**Must not be fabricated:** there are no testimonials, no client logos, no traffic or performance metrics, no revenue or user numbers, no awards. Do not invent them, and do not imply them through design placeholders. The 350+ Remote Ruby episode count and the "about a decade" of Rails are the only quantities currently claimed; both are real and should be kept accurate rather than inflated.

Note: the user did not pin the existing bio _wording_ as fixed — copy may be rewritten. The underlying facts above must stay true.

## Product Principles

1. **The first viewport is the resume.** A hiring manager who reads nothing else should come away with an accurate, favorable, specific read. Depth signals over adjectives.
2. **Deep links are front doors.** Most readers never see the homepage. A post page has to stand alone: orient the stranger, prove the author, offer the next thing.
3. **Publishing friction is a design bug.** Any change that makes writing a post harder is a regression, regardless of how it looks.
4. **Accumulation is the argument.** Specific artifacts — posts, talks, tools, episodes — carry the credibility. Design frames them; it never substitutes claims for them.
5. **Understated over emphatic.** The voice earns trust by not selling. Confidence reads as restraint here.

## Accessibility & Inclusion

No product-specific standard was established beyond ordinary good practice. Both themes are first-class and must both be legible; contrast, focus visibility, and keyboard navigation are expected to hold in each.

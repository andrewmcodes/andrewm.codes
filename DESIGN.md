---
name: andrewm.codes
description: The personal site of Andrew Mason — a dark-first slate ground, one ruby accent spent only on state, and hairline rules instead of shadows.
colors:
  slate-1: "#fcfcfd"
  slate-2: "#f9f9fb"
  slate-3: "#f0f0f3"
  slate-4: "#e8e8ec"
  slate-5: "#e0e1e6"
  slate-6: "#d9d9e0"
  slate-7: "#cdced6"
  slate-8: "#b9bbc6"
  slate-9: "#8b8d98"
  slate-10: "#80838d"
  slate-11: "#60646c"
  slate-12: "#1c2024"
  ruby-3: "#feeaed"
  ruby-5: "#ffced6"
  ruby-6: "#f8bfc8"
  ruby-8: "#e592a3"
  ruby-9: "#e54666"
  ruby-11: "#ca244d"
  ruby-12: "#64172b"
  amber-500: "oklch(76.9% 0.188 70.08)"
typography:
  display:
    fontFamily: "Archivo Variable, ui-sans-serif, system-ui, sans-serif"
    fontSize: "clamp(38px, 6.2vw, 68px)"
    fontWeight: 600
    lineHeight: 1.02
    letterSpacing: "-0.03em"
  headline:
    fontFamily: "Archivo Variable, ui-sans-serif, system-ui, sans-serif"
    fontSize: "clamp(28px, 4vw, 42px)"
    fontWeight: 600
    lineHeight: 1.1
    letterSpacing: "-0.028em"
  page-title:
    fontFamily: "Archivo Variable, ui-sans-serif, system-ui, sans-serif"
    fontSize: "30px"
    fontWeight: 600
    lineHeight: 1.2
    letterSpacing: "-0.022em"
  h2:
    fontFamily: "Archivo Variable, ui-sans-serif, system-ui, sans-serif"
    fontSize: "25px"
    fontWeight: 600
    lineHeight: 1.25
    letterSpacing: "-0.02em"
  h3:
    fontFamily: "Archivo Variable, ui-sans-serif, system-ui, sans-serif"
    fontSize: "20px"
    fontWeight: 600
    lineHeight: 1.35
    letterSpacing: "-0.012em"
  read:
    fontFamily: "Source Serif 4 Variable, ui-serif, Georgia, serif"
    fontSize: "18px"
    lineHeight: 1.7
  title:
    fontFamily: "Archivo Variable, ui-sans-serif, system-ui, sans-serif"
    fontSize: "17px"
    fontWeight: 550
    lineHeight: 1.35
    letterSpacing: "-0.015em"
  lede:
    fontFamily: "Archivo Variable, ui-sans-serif, system-ui, sans-serif"
    fontSize: "16.5px"
    lineHeight: 1.55
  row:
    fontFamily: "Archivo Variable, ui-sans-serif, system-ui, sans-serif"
    fontSize: "15.5px"
    fontWeight: 500
    lineHeight: 1.4
    letterSpacing: "-0.008em"
  body:
    fontFamily: "Archivo Variable, ui-sans-serif, system-ui, sans-serif"
    fontSize: "15px"
    lineHeight: 1.6
  note:
    fontFamily: "Archivo Variable, ui-sans-serif, system-ui, sans-serif"
    fontSize: "13.5px"
    lineHeight: 1.5
  code:
    fontFamily: "Geist Mono Variable, ui-monospace, Menlo, monospace"
    fontSize: "13.5px"
    lineHeight: 1.5
  label:
    fontFamily: "Geist Mono Variable, ui-monospace, Menlo, monospace"
    fontSize: "12px"
    fontWeight: 500
    lineHeight: 1.4
    letterSpacing: "0.08em"
  meta:
    fontFamily: "Geist Mono Variable, ui-monospace, Menlo, monospace"
    fontSize: "11.5px"
    lineHeight: 1.5
  micro:
    fontFamily: "Geist Mono Variable, ui-monospace, Menlo, monospace"
    fontSize: "10.5px"
    fontWeight: 500
    lineHeight: 1.4
    letterSpacing: "0.06em"
rounded:
  none: "0px"
  sm: "4px"
  md: "6px"
  lg: "8px"
  mark: "10px"
  xl: "12px"
  focus: "4px"
  full: "9999px"
spacing:
  rail: "168px"
  rail-gap: "40px"
  aside: "208px"
  aside-gap: "56px"
  ledger: "300px"
  row: "14px"
  row-media: "18px"
  row-full: "20px"
  tile: "20px"
  gutter: "36px"
  gutter-mobile: "16px"
  section: "56px"
  page-top: "64px"
  page-bottom: "96px"
  measure: "65ch"
components:
  button-primary:
    backgroundColor: "{colors.slate-2}"
    textColor: "{colors.ruby-11}"
    typography: "{typography.note}"
    rounded: "{rounded.md}"
    padding: "10px 14px"
  button-primary-hover:
    backgroundColor: "{colors.ruby-3}"
    textColor: "{colors.ruby-11}"
  button-secondary:
    backgroundColor: "{colors.slate-3}"
    textColor: "{colors.slate-12}"
    typography: "{typography.note}"
    rounded: "{rounded.md}"
    padding: "10px 14px"
  button-secondary-hover:
    backgroundColor: "{colors.slate-4}"
  button-ghost:
    backgroundColor: "transparent"
    textColor: "{colors.slate-11}"
    typography: "{typography.note}"
    rounded: "{rounded.md}"
    padding: "10px 14px"
  button-ghost-hover:
    backgroundColor: "{colors.slate-3}"
  button-share:
    backgroundColor: "transparent"
    textColor: "{colors.slate-10}"
    typography: "{typography.meta}"
    rounded: "{rounded.none}"
    padding: "0 0 2px"
  button-share-hover:
    textColor: "{colors.ruby-11}"
  nav-link:
    backgroundColor: "transparent"
    textColor: "{colors.slate-11}"
    typography: "{typography.note}"
    rounded: "{rounded.md}"
    padding: "6px 10px"
  nav-link-hover:
    backgroundColor: "{colors.slate-3}"
    textColor: "{colors.slate-12}"
  nav-link-active:
    textColor: "{colors.slate-12}"
  nav-link-drawer-active:
    backgroundColor: "{colors.ruby-3}"
    textColor: "{colors.ruby-11}"
    typography: "{typography.body}"
    rounded: "{rounded.md}"
    padding: "12px 16px"
  entry-compact:
    backgroundColor: "transparent"
    textColor: "{colors.slate-12}"
    typography: "{typography.row}"
    rounded: "{rounded.none}"
    padding: "14px 0"
  entry-compact-hover:
    textColor: "{colors.ruby-11}"
  entry-media:
    backgroundColor: "transparent"
    textColor: "{colors.slate-12}"
    typography: "{typography.row}"
    rounded: "{rounded.none}"
    padding: "18px 0"
  entry-media-hover:
    backgroundColor: "{colors.slate-2}"
  entry-lead:
    backgroundColor: "transparent"
    textColor: "{colors.slate-11}"
    typography: "{typography.meta}"
    width: "{spacing.rail}"
  tile:
    backgroundColor: "{colors.slate-1}"
    textColor: "{colors.slate-11}"
    typography: "{typography.row}"
    rounded: "{rounded.none}"
    padding: "{spacing.tile}"
  tile-hover:
    backgroundColor: "{colors.slate-2}"
  tile-chip:
    backgroundColor: "transparent"
    textColor: "{colors.slate-10}"
    typography: "{typography.micro}"
    rounded: "{rounded.none}"
  tile-chip-accent:
    textColor: "{colors.ruby-11}"
  section-label:
    backgroundColor: "transparent"
    textColor: "{colors.slate-11}"
    typography: "{typography.label}"
    width: "{spacing.rail}"
  input-search:
    backgroundColor: "transparent"
    textColor: "{colors.slate-12}"
    typography: "{typography.row}"
    rounded: "{rounded.none}"
    padding: "0px"
  palette-panel:
    backgroundColor: "{colors.slate-2}"
    textColor: "{colors.slate-11}"
    rounded: "{rounded.md}"
    width: "min(580px, 92vw)"
  kbd:
    backgroundColor: "{colors.slate-3}"
    textColor: "{colors.slate-11}"
    typography: "{typography.meta}"
    rounded: "{rounded.sm}"
    padding: "1px 6px"
  toc-link:
    backgroundColor: "transparent"
    textColor: "{colors.slate-11}"
    typography: "{typography.note}"
    rounded: "{rounded.none}"
  toc-link-current:
    textColor: "{colors.ruby-11}"
  note:
    backgroundColor: "{colors.slate-2}"
    textColor: "{colors.slate-11}"
    rounded: "{rounded.xl}"
    padding: "16px"
  note-accent:
    backgroundColor: "{colors.ruby-3}"
    textColor: "{colors.ruby-12}"
    rounded: "{rounded.xl}"
    padding: "16px"
  note-stale:
    backgroundColor: "transparent"
    textColor: "{colors.slate-12}"
    typography: "{typography.note}"
    rounded: "{rounded.lg}"
    padding: "16px"
  theme-toggle:
    backgroundColor: "{colors.slate-3}"
    textColor: "{colors.slate-10}"
    rounded: "{rounded.full}"
    padding: "4px"
    size: "32px"
  theme-toggle-active:
    backgroundColor: "{colors.slate-5}"
    textColor: "{colors.slate-12}"
    rounded: "{rounded.full}"
---

# Design System: andrewm.codes

## Overview

**Creative North Star: "The Standard, Played Straight"**

This is the familiar arrangement for a working engineer's site — a name, a standfirst, a ledger of what exists, then ruled lists of writing and open source — built at a craft level the category rarely reaches. The invention is not in the layout. It is in the focus ring you can't lose, the hover that arrives on the one element you pointed at, the row that reveals its arrow only when you're on it, and the fact that both themes are real. Convention carries the structure so that every unit of attention can be spent on state, timing, and contrast.

The ground is a Radix slate ramp, composed dark-first: dark is where the design was made and reviewed, light is a tested peer. There is exactly one accent — Radix ruby — and it is spent entirely on state: hover, focus, active, current. There is deliberately no solid ruby field at rest anywhere on the site, including the primary button, which is a ruby hairline with a ruby-11 label. Surfaces are separated by a 1px slate-6 rule and never by a shadow. Three typefaces divide the work absolutely: Archivo for chrome and lists, Source Serif 4 for the reading column and nowhere else, Geist Mono for anything that is a measurement.

The one compositional idea is the label rail: a 168px margin on the left carrying what a section is called, what it holds, and where the rest of it lives, with the column beside it carrying nothing but the work. The same 168px is the lead column of a chronological row, so a section label and the dates under it hang in the same margin. Below 820px the rail stacks, because a 168px margin is a luxury a phone does not have. This system was built code-led against the running site; there are no comps, and nothing here is derived from a design file.

The confirmed anti-reference is the **landing page**: a solid accent field as a first object, a card grid used as the default primitive, a small coloured line above a title, decorated section headings. Each of those was present at some point in the build and was removed by measurement.

**Key Characteristics:**

- One ground (Radix slate, all 12 steps) and one accent (Radix ruby, spent only on state). Every other colour arrives by one of three narrow routes — a borrowed semantic (amber, staleness only), upstream data (GitHub's language colours), or a one-axis derived fallback (the podcast hue).
- Every ramp step is redefined per `[data-theme]`, so the token **value** flips rather than the class — markup carries almost no `dark:` variants.
- Three faces with strictly divided jobs: **Archivo** (chrome, lists, display), **Source Serif 4** (the reading column only), **Geist Mono** (dates, counts, durations, tags, code, labels).
- Fifteen named type roles in `@theme`, each carrying its own leading, tracking, and weight, so `text-meta` is the whole decision.
- Two layout primitives carry nearly the whole site: `Entry` (one chronological row, three densities) and `Tile` (one grid cell for peers).
- A 1px slate-6 hairline is the only separator for anything that scrolls with the page.
- Focus is a single base-layer rule over every focusable element, so it cannot be forgotten per component.
- Links are underlined, not coloured — ruby against body slate measured 1.09:1 and colour alone was not a distinction.

## Colors

A near-monochrome slate interface with one red accent reserved for state, drawn from Radix UI Colors (Slate + Ruby + Amber) and inlined as CSS custom properties in `frontend/styles/index.css` so they can be scoped to `[data-theme]` rather than Radix's own `.dark` class selectors. `node_modules/@radix-ui/colors/{slate,ruby,amber}[-dark].css` is the source of truth for every step; values are copied, not eyeballed.

Every slate and ruby token is a **light/dark pair**. The frontmatter carries the light value as canonical; the dark counterpart for each is in `.impeccable/design.json` under `extensions.colorMeta`. The pairs are perceptually matched, not inverted — slate-11 is a mid-dark grey on paper and a mid-light grey on ink, and both read as "secondary text."

### Primary

- **Signal Ruby** (`ruby-11`): the accent, and the only one. It carries every hover on rows, tiles, nav items, footer links, ledger rows, and contents entries; the active-tab underline in the topbar; the current entry in the reading rail; the primary button's label; the blockquote rule; the bullet-thread dot ring; the heading-anchor hover; and the text caret. A deep crimson on paper and a warm rose on ink.
- **Focus Ruby** (`ruby-9`): the focus ring, and the primary button's resting border at 50% opacity. The only fully saturated step in use, and it appears only as a 2px line.
- **Ruby Wash** (`ruby-3`): the primary button's hover fill, the active item in the mobile drawer, and the accent callout background. The nearest thing to a ruby surface on the site, and it exists only as a hover or a current state.
- **Ruby Edge** (`ruby-6`): the accent callout's border. **Ruby Ring** (`ruby-8`): the theme toggle's inset focus ring, used because its buttons sit flush inside a track where a 2px offset outline would clip.
- **Selection Ruby** (`ruby-5` fill, `ruby-12` text): `::selection`. Also `ruby-12` for text on ruby-tinted surfaces and the accent heading scheme.

### Neutral

Slate carries the entire interface. All twelve steps are bridged and all twelve are used.

- **Ground** (`slate-1`): the page background, the resting tile fill, the fill behind the translucent topbar and mobile drawer, the podcast mark's glyph colour, and the bullet-thread dot centre.
- **Raised** (`slate-2`): one tonal step up, never more — the command palette shell, the Markdown-actions dropdown, the tile hover fill, the entry hover bleed, the primary button's resting field, the plain-`<pre>` dev fallback.
- **Control Fill** (`slate-3`): secondary button, nav hover, inline `<code>`, keyboard caps, the theme-toggle track, the copy-code button.
- **Faint Fill** (`slate-4`): secondary button hover, the dev `<pre>` fallback border, the webmention avatar placeholder.
- **Edge** (`slate-5`): the heavier 1px — link underlines, the palette panel border and its internal divisions, `<kbd>` outlines, the post footer and related-posts rules, the theme toggle's selected pill, the Markdown-actions control border. Used where a line must read as an edge rather than a divider.
- **Hairline** (`slate-6`): the universal separator — entry rows, the card grid, section rules, the ledger rows, the contents rail's top rule, the footer top border, the bullet-thread spine, inline-code borders, the mobile drawer's bottom border. The most structurally load-bearing colour in the system.
- **Faint Ink** (`slate-7`, `slate-8`): the resting heading anchor and drawer chevron (`7`); the palette placeholder, the `#` before a tag, the resting entry arrow, the brand-lockup slash, and the scrollbar thumb (`8`).
- **Quiet Ink** (`slate-9`, `slate-10`): related-post dates (`9`); monospace metadata that is not carrying primary information — tile footers, chips, back links, section actions, source notes, palette hints (`10`).
- **Body Ink** (`slate-11`): all body copy, secondary text, prose paragraphs, entry excerpts, and the mono facts sitting under a title. Numerically the most-used token in the codebase.
- **Full Ink** (`slate-12`): headings, entry and tile titles, and any text that must win a scan.

### Tertiary (data-carrying, not brand)

Three colours originate outside slate and ruby, and they arrive by three different routes: one is a borrowed semantic, one is upstream data, one is derived. None is a second accent; each is doing a job the accent physically cannot, because its **value** is the information.

- **Stale Amber** (Tailwind `amber-500`) — _borrowed semantic_: the stale-post notice only, a `/30` border on a `/5` wash with a solid-amber icon, raised on posts whose last update is more than two years old. Allowed because "this may be out of date" is a caution the brand red would misreport. **Note the gap:** `@theme` bridges a deliberate four-step Radix amber subset (`amber-3`, `-6`, `-9`, `-11`, themed per `[data-theme]`), but nothing references it — the shipped notice uses Tailwind's own `amber-500`, which does not flip between themes. The bridge is currently unused; the Tailwind value is what renders.
- **Language dot** (upstream GitHub value) — _upstream data_: the 8px dot on a tile's fact row, taken from GitHub's own language colours so Ruby reads as Ruby. This is not a choice the site makes; the ecosystem already assigns it, and the dot simply reports it. Falls back to `#701516`.
- **Podcast hue** (`oklch(0.62 0.14 <hue>)`) — _derived identifier_: the 56px rounded mark on a podcast row, where `<hue>` comes from `accent_hue` in `src/_data/podcasts.yml` and an inactive show drops to `opacity: 0.7`. **Lightness and chroma are fixed and hue is the only free variable** — the whole reason a column of shows reads as one family rather than five unrelated colours. It is also a _fallback_ identity: every show currently in the data carries real artwork that covers the mark, so the generated hue surfaces only for a show with no image, or if an image fails to load.

### Named Rules

**The Accent-Is-State Rule.** Ruby marks what is hovered, focused, active, or current — and nothing else. There is deliberately no solid ruby field at rest anywhere on the site. The primary button proves the rule rather than excepting it: the solid fill it replaced put white on `ruby-9` at 3.89:1, under the 4.5:1 its 13.5px label needs, and read as the most landing-page-shaped object on the page. The hairline version measures 5.16:1 in light and 8.36:1 in dark, and the fill still arrives on hover. At rest a full viewport should hold almost no ruby at all — often only the period after the wordmark and one active nav underline.

**The Upstream-Colour Rule.** A colour outside slate and ruby is admissible when it is data the site did not author. GitHub's language colour on a project tile is the case: Ruby reading red is information the ecosystem already assigns, and the dot reports it rather than deciding it. Accept it plainly — no caveat, no re-mapping into the palette, no "brand-safe" substitute, because a substituted language colour is simply wrong. Amber for staleness is the one borrowed _semantic_ rather than borrowed data: "may be out of date" is a caution the brand red would misreport, so the convention is borrowed instead of invented.

**The Derived-Identifier Rule.** A colour may be **generated** only when the generation is constrained to one axis and the result is a fallback. The podcast mark is `oklch(0.62 0.14 <hue>)` with `accent_hue` supplied per show: **lightness and chroma are fixed and hue is the only free variable**, which is the entire reason a column of shows reads as one family rather than as five unrelated colours. It is also a fallback identity, not a primary one — every show in the data carries real artwork that covers the mark, so the generated hue surfaces only for a show with no image. Widen the generation to lightness or chroma and you have invented a palette; use it where artwork exists and you have invented decoration. Neither this rule nor the one above is licence to invent a decorative colour: if a new colour cannot answer "what fact does this encode?", it does not go in.

**The Dark-First Rule.** Both themes ship and both must be legible, but dark is the composed ground and light is the tested peer. The mechanism is why the system stays small: because every ramp step is redefined inside `[data-theme="dark"]`, the token **value** flips rather than the class, so `text-slate-11` is correct in both themes and markup needs almost no `dark:` variants. Author a new colour as a light/dark pair in `frontend/styles/index.css` and the rest is free.

**The Bridge Rule.** A Radix step is usable in markup only if it has been bridged into `@theme` as `--color-<name>`. An unbridged utility produces silence, not an error — the class does nothing and the element falls back to inherited colour. Slate and ruby are bridged in full precisely so a step is never referenced before it exists; amber is a deliberate four-step subset. Add the bridge and the usage in the same change.

## Typography

**Display / Interface Font:** Archivo Variable (with `ui-sans-serif, system-ui, sans-serif`) **Reading Font:** Source Serif 4 Variable (with `ui-serif, Georgia, serif`) **Measurement / Mono Font:** Geist Mono Variable (with `ui-monospace, Menlo, monospace`)

All three are self-hosted via `@fontsource-variable/*` and imported from `frontend/javascript/index.js`.

**Character:** A grotesque with real presence at display size against a serif built for long reading against a mono built for numerals. None of the three is expressive on its own — the expression is entirely in _which one is used where_. Archivo never sets an article paragraph; Source Serif never appears in chrome; Geist Mono never sets a sentence.

Sizes are **named roles** declared in `@theme`, not raw scale steps. Each role carries its own line-height, letter-spacing, and weight, so `text-meta` is one decision rather than four classes that drift apart. The family is a separate utility; the pairing below is the convention every call site in the codebase follows.

### Hierarchy

- **Display** (Archivo 600, `clamp(38px, 6.2vw, 68px)`, `1.02`, `-0.03em`): the homepage `<h1>` only. Sub-solid leading and tight tracking make a two-word name read as a mark. Capped at 680px and balanced.
- **Headline** (Archivo 600, `clamp(28px, 4vw, 42px)`, `1.1`): post titles.
- **Page title** (Archivo 600, `30px`, `1.2`): index and listing page titles via `Ui::PageHeader`. A listing is a room, not an argument.
- **H2 / H3** (Archivo 600, `25px` / `20px`): article headings inside the reading column. They must outrank the prose they head by an obvious step — at 17px against 17px body the sections read flat, and an h3 below body size loses to its own paragraph.
- **Read** (Source Serif 4, `18px`, `1.7`): the reading column and nothing else. Constrained to a **65ch measure**, chosen in-browser against real character width at this size.
- **Title** (Archivo 550, `17px`, `1.35`): the largest type inside a list — the year marker over an archive group.
- **Lede** (Archivo, `16.5px`, `1.55`): the hero standfirst and page descriptions. One step above interface body and deliberately tighter than the serif column it must not imitate.
- **Row** (Archivo 500, `15.5px`, `1.4`, `-0.008em`): every entry and tile title, the palette input, the topbar wordmark. Close to body size on purpose — a list is scanned as a body of work, not as a stack of headlines.
- **Body** (Archivo, `15px`, `1.6`): the global default set on `<body>`. Interface copy, drawer items.
- **Note** (Archivo, `13.5px`, `1.5`): excerpts, descriptions, section descriptions, contents entries, button labels. Supporting copy runs at this step with `leading-snug`.
- **Code** (Geist Mono, `13.5px`, `1.5`): fenced code blocks, Torchlight-highlighted and the plain dev fallback alike. Set below the 18px reading column on purpose — a wide sample has to fit the measure without horizontal scroll before it has to match the text. Inline `<code>` is separate and inherits its surrounding size.
- **Label** (Geist Mono 500, `12px`, uppercase, `0.08em`): section labels in the rail, and the contents heading. The signature type treatment of the site.
- **Meta** (Geist Mono, `11.5px`, `1.5`): dates, reading times, durations, tags, counts, keyboard caps, footer, post navigation, palette hints. `font-variant-numeric: tabular-nums` is set globally on `.font-mono`, so numerals align in a column.
- **Micro** (Geist Mono 500, `10.5px`, uppercase, `0.06em`): tile chips.

The only size in the codebase outside these roles is the podcast mark's glyph (`text-lg`, `text-sm` below `sm`) — a mark size rather than a type role.

### Named Rules

**The Named-Role Rule.** Every size on the site is one of the fifteen roles in `@theme`. Never write a raw `text-[15px]`, never pair a role with a competing `leading-*`/`tracking-*`/`font-*` unless the override is the point, and if a new size is genuinely needed, add a role with all four properties rather than assembling one at a call site. The only sanctioned exception is a glyph inside a mark, where the size is artwork.

**The Three-Voices Rule.** Chrome, lists, and display are Archivo. The reading column is Source Serif 4 and nothing else is. Anything that is a measurement — a date, a count, a duration, a tag, a keyboard cap, a code span, a section label — is Geist Mono. There is no fourth category and no overlap: if a small line is a sentence rather than a measurement, it is sans, even at 13.5px in a margin.

**The Underline Rule.** Links in the reading column are underlined, not coloured. Ruby-11 against body slate measures 1.09:1 in light and 1.01:1 in dark, so colour alone was not a distinction at all — WCAG 1.4.1 wants 3:1 for a colour-only difference. The underline is the affordance and the colour is only reinforcement: `decoration-ruby-11/40` at rest going solid on hover, over a global `text-underline-offset: 0.2em`.

**The No-Kicker Rule.** No kicker, ever. A small accent line above a title is an eyebrow. It existed as an `Entry` parameter and was deleted: the show, the venue, the episode number and the city are facts _about_ the item, not headings _over_ it, and they live in the meta row with the other facts.

**The Label-Not-Title Rule.** Section labels are never large. `now`, `featured work`, `recent posts`, `Talks` are 12px mono uppercase `0.08em` in slate-11, hanging in the rail above a hairline — a filing tab, not a banner. Hierarchy is carried by the ruled structure and by which face is used, not by making headings big.

## Layout

A single centred column with a label rail, one gutter, no sidebars. `PageShell` owns page width in three sizes: **wide** (`1080px`, `36px` gutter) for the homepage and listings, **reading** (`940px`) for posts — wide enough to hold its own apparatus in the margin while the column beside it stays at a reading measure, not wide enough for the prose itself to grow — and **narrow** (`720px`, `32px` gutter) for simple pages. All collapse to a `16px` gutter below `768px`. The topbar and footer independently repeat the wide shell's `1080px / 36px` measurements, so all three align to the same edge at every width.

**The label rail is the one compositional idea.** `PageSection` is a `168px / minmax(0,1fr)` grid with a `40px` gap and a `slate-6` rule across the full measure: the label, its one-line description, and its "everything else" action hang in the margin; the column beside it carries only the work. The compact `Entry` uses the same `168px` lead column so a section label and the dates beneath it occupy one margin — at 96px the archive quietly ran a second grid and the site's one idea broke on the page where it should be clearest. Both stack at `nav` (820px).

The reading page is the same idea one step wider: a `208px / minmax(0,1fr)` grid at a `56px` column gap, with `PostAside` in the margin carrying the back link, date, reading time, byline, tags, and contents — everything true _about_ the post, kept out of the post itself. On desktop the rail is sticky at `top-24` and spans two grid rows in column one, while column two is split into the title (row 1) and the body (row 2). That split exists only to buy the mobile order: below `nav` the grid becomes one column and `order` puts the **title first, the apparatus second, the article third**, so a reader who just tapped a headline meets the thing they opened rather than its metadata. The rail's grid placement is passed in by the layout rather than owned by the component, so the same aside can be positioned differently without forking it.

Vertical rhythm is coarse and consistent: listing pages open at `64px` and close at `96px`; sections are separated by `56px`. Homepage sections use a tighter `48px` because the hairlines already do the separating, and one — the `now` block directly under the hero — uses a `home_coda` step (`8px` top, `80px` bottom) that binds it to the hero above and opens a large gap below, so the page reads as a peak followed by an even body rather than as six sections at identical pitch.

`Entry` comes in three densities against a hairline, and density decides only how much room one entry gets, never what it is made of: **compact** (`168px / 1fr / auto`, `14px` padding, baseline-aligned) for scanning a year of writing; **full** (`120px / 1fr`, `20px` padding, hover bleed) for one item given room to argue for itself with an excerpt and named resource links; **media** (`64px / 1fr / auto`, `18px` padding, centre-aligned, hover bleed) for anything fronted by artwork rather than a date. Compact collapses to one column at `md`; full and media at `sm`. The lead column is measurement, and on a phone it belongs above the title rather than beside it.

The homepage hero is the one place the page is genuinely two columns: a prose column beside a `300px` derived ledger, `64px` apart, collapsing to stacked at `nav`. The `now` list runs its own `92px / 1fr` grid. Everywhere else, responsiveness is a matter of gutters and where a grid collapses.

Breakpoints are Tailwind's defaults (`sm` 640, `md` 768, `lg` 1024) plus two declared in `@theme` because they are load-bearing and don't map onto the default scale: **`nav` at 820px** (primary nav collapses to the hamburger; the hero, the label rail, and the reading rail all unstack) and **`compact` at 520px** (the `@handle`, the "Search" word and the ⌘K cap drop; header height goes `64px` → `56px`). Naming them keeps arbitrary `min-[820px]` values out of markup. The card grid has its own `680px` break where two columns become one.

Zero horizontal overflow was verified across twenty captures at 1440 and 390 in both themes. Markdown tables scroll inside the prose column rather than forcing the page to.

### Named Rules

**The Rows-for-Chronology Rule.** Dated content is an `Entry` — posts, talks, episodes, CFPs, appearances, shows. Genuinely parallel items with no meaningful order may `Tile` — projects, featured work. **A grid never carries dated content.** This is why writing, speaking, and podcasting read as one body of work rather than four lists that merely resemble each other, and it is the reason a card grid is not the site's default primitive.

**The Label-Rail Rule.** Apparatus goes in the margin; the column carries the work. What a section is called, what it holds, where the rest of it lives, when a post was written, how long it takes, what is in it — all of that hangs in a 168px (or 208px) left rail, and it stacks rather than shrinks below `nav`. Never inline apparatus into the content column on desktop, and never open a second rail inside a rail: the archive's year marker sits at the left edge sharing a column with the dates below it, because giving it its own 168px column stacked two margins and opened a gap down the middle of the page.

**The One-Column Rule.** Content is a single centred column at every width. No sidebar, no asymmetric listing page, no two-up article layout. The homepage hero is the single sanctioned exception: it may pair a prose column with one narrow derived ledger, collapsing to stacked at `nav`.

## Elevation & Depth

**This system is flat.** Separation is carried entirely by 1px hairlines and by single-step tonal shifts (`slate-1` → `slate-2` on tile and row hover). Content surfaces have no shadow at any state. The two floating panels that would conventionally carry the largest shadows on a site — the command palette and the mobile drawer — deliberately have none: the palette is a `slate-2` field with a `slate-5` border over a `bg-slate-1/70 backdrop-blur-sm` scrim, and the drawer is a `slate-1/95` plate with a `slate-6` bottom border. Elevation comes from the border and the field.

`slate-6` was chosen for the hairline by measurement: 1.37:1 in light and 1.65:1 in dark against the ground, where `slate-4` measured 1.19 / 1.31 and disappeared. Tiles are not boxes; they are regions bounded by rules, which is why `.card-grid` draws its hairlines on the children (`border-bottom`, `border-right` on odd cells) rather than using a coloured gap — an odd card count must not leave a filled cell behind. `Entry` gets its hover surface from a `::before` inset `-12px` horizontally and `4px` vertically at `-z-10` with a 6px radius, so a row tints without becoming a box and the separator stays the hairline.

### Shadow Vocabulary

Three shadows survive, all small, none on anything that scrolls with the page as content:

- **Popover** (`shadow-lg`: `0 10px 15px -3px rgb(0 0 0 / .1), 0 4px 6px -4px rgb(0 0 0 / .1)`): the Markdown-actions dropdown on a post — the only non-modal popover on the site, and the only shadow inside the reading column.
- **Selected control** (`shadow-sm`: `0 1px 3px 0 rgb(0 0 0 / .1), 0 1px 2px -1px rgb(0 0 0 / .1)`): the selected pill in the theme toggle, so the chosen mode reads as pressed inside its track.
- **Framed image** (`shadow-lg` plus `ring-1 ring-slate-6`): the `Image` component's `figure` variant, where a slate hairline alone would disappear into the ground the image sits on.

Two non-shadow depth devices carry real weight: the topbar's `bg-slate-1/85 backdrop-blur backdrop-saturate-150`, which lets content pass under it as a translucent plate and drops to opaque via `header:has(#mobile-menu[data-open="true"])` while the drawer is open; and the bullet thread on the Now and Uses pages, where a 1px vertical `slate-6` line and 8px `ruby-11`-ringed dots imply a spine with no elevation at all.

### Named Rules

**The Hairline-Not-Shadow Rule.** When two regions need separating, the answer is a 1px `slate-6` line. If an element scrolls with the document, it is flat — no exceptions, including tiles, rows, sections, and the reading rail. A shadow is admissible only on a genuine popover or a selected control, and even a modal here does without one.

## Shapes

Radii are small and functional, and the pattern is that **the more an element floats, the rounder it gets** — but the range is narrow on purpose. Content that sits in the document has no radius at all: entry rows, card-grid cells, section rules, and the ledger are square, because a hairline-ruled list has no corners to round. Controls and floating panels are `6px` (`rounded-md`) — buttons, nav links, drawer items, the topbar's icon buttons, the split Markdown-actions control, the command palette panel, the drawer's bottom corners, the entry hover bleed. Small chips are `4px` (keyboard caps, inline code, the active-tab underline's cap) or fully pill (the theme toggle and its buttons, avatars). The stale note is `8px`, callouts are `12px`, and the podcast mark is a squircle-ish `10px`. The focus ring's own `4px` radius is declared once in the base rule.

Borders are always `1px` and almost always a slate step — `slate-6` for a divider, `slate-5` for an edge — with three exceptions, each of which is state or data: the primary button's `ruby-9/50` edge going solid on hover, the accent callout's `ruby-6`, and the stale note's `amber-500/30`. The blockquote is the only heavy rule in the system: a `3px` `ruby-11` left border, un-italicised, with `slate-12` text. The active-tab marker is a `1.5px` `ruby-11` bar inset `10px` from each edge of its link.

Icons are inline SVG at `15px` default (`14px` in chrome, `11–12px` in metadata rows and back links), `stroke-width: 2` (`1.8` on the back arrow), round caps and joins, `currentColor`, so they inherit the accent on hover along with their text. GitHub's star and fork marks are deliberately **not** used: they are filled where the site's set is stroked, and two icon languages in one footer would say what two nouns already say — so the tile fact row reads "12 stars · 3 forks" in words.

### Named Rules

**The Square-Content Rule.** Anything that scrolls with the page and is separated by a hairline is square. Radius is for controls, chips, and things that float.

## Components

Two primitives carry nearly the whole site. Almost every other component in `src/_components/` is a thin adapter that maps one data shape onto `Entry` or `Tile` — `PostRow`, `MetaRow`, `PodRow`, `TalkCard`, and `EpisodeCard` all render an `Entry`; `ProjectCard` and `FeaturedCard` both render a `Tile`. Add data shapes, not primitives.

### Entry (signature component)

The site's one chronological row, and the clearest expression of the North Star. A post, a talk, an episode, a show, a CFP, and an appearance are the same object here: a lead column of measurement, a title carrying its own facts, and an optional trailing note.

- **Structure:** lead column (mono date and optional duration, or a 56px artwork mark) / title with excerpt, hash-prefixed tags, middot-joined mono facts, and named resource links / trailing column. Density (`compact`, `full`, `media`) sets columns, gap, padding, and alignment — and nothing else.
- **At rest:** entirely slate. Nothing underlined, nothing coloured, nothing boxed. A `slate-6` bottom border is the only structure.
- **Hover / Focus:** the whole row is the anchor and the whole row responds — the title goes `ruby-11`, and the trailing arrow **arrives**: `opacity-0 -translate-x-1` → `opacity-100 translate-x-0` in `ruby-11`, on `group-hover` and `group-focus-visible` alike. At rest that arrow repeated down forty-five rows carrying no information, which is most of what made the archive read as one undifferentiated block.
- **Inert rows are first-class.** A talk with several destinations (video, slides) stays inert and names its resources as underlined mono links; a show with no real URL renders as a row rather than a dead anchor.

### Tile

The site's one grid cell, for peers rather than chronology. A `slate-1` region bounded by the grid's hairlines, going `slate-2` on hover — one tonal step, no lift, no scale, no shadow.

- **Corner style:** square. `.card-grid` draws `border-top` on the container and `border-bottom` / `border-right` on the children.
- **Internal padding:** `20px` at `md` and up; `14px` vertical with no horizontal padding below that, so tiles flush to the page gutter on mobile.
- **Fact row:** every tile ends with a mono `11.5px` footer of facts — a language dot, star and fork counts as words, or a kind label — pinned with `mt-auto` so a row of unequal tiles still aligns its footers.
- **Chip:** mono `10.5px` uppercase in `slate-10`, set to the row's right, `ruby-11` when it carries the accent. **Only a status worth remarking on earns one** — nearly every project is active, so labelling them all said nothing and spent the accent fifteen times on one page.

### Page Section (signature component)

The label rail: a `slate-6` rule across the measure, a 168px margin carrying the mono uppercase label, an optional one-line description in `13.5px` slate, and an optional "everything else" action as underlined mono going ruby on hover with a 2px icon nudge. The content column beside it is untouched. Stacks at `nav` with a `20px` gap under the label block.

### Reading Rail and Contents

`PostAside` is the reading page's margin: back link, then a mono `<dl>` of date, reading time, and byline (a vertical stack in the rail, re-flowing to a horizontal wrapped row below `nav`), then tags, then contents. Sticky at `top-24` on desktop, spanning both grid rows. Below `nav` it sits between the title and the article rather than above both — the apparatus must not be the first thing a reader meets after tapping a headline. Its grid placement is passed in as a class by the layout, so the component owns its content and the page owns where it goes.

Contents is filled at build time by `Builders::Inspectors::Toc`, which reads the **real rendered headings** rather than parsing source markdown — so the entries agree with the anchor IDs the reader actually lands on, and anything a component generated is included. It appears only on posts over 800 words that haven't opted out, and never for a single heading, which is a heading with extra steps. One rendering serves both breakpoints: a `<details>` whose summary shows only below `nav`, opened on desktop by `toc.js` so the rail behaves as a rail. The current entry is marked with `aria-current="true"` and styled off that attribute, so the accessible state and the visual state cannot drift apart; positions are read live on scroll against a 120px line just under the sticky header.

### Buttons

- **Shape:** `6px`, or a full circle when `circle: true`. Five sizes from `xs` to `xl`; every size above `sm` shares the same `13.5px` label, so the scale is padding, not type.
- **Primary:** a `slate-2` field with a `ruby-9/50` hairline and a `ruby-11` label — **no solid accent field at rest**. Hover fills to `ruby-3` and the border goes solid. 5.16:1 in light, 8.36:1 in dark.
- **Secondary:** `slate-3` fill, `slate-12` text, no border, `slate-4` on hover. **Ghost:** transparent, `slate-11`, `slate-3` on hover. **Text:** transparent with no hover surface at all.
- **Share:** not a button shape — `11.5px` mono on a `slate-5` bottom border, going ruby on hover. The same visual language as the `action` and `section_action` link variants, and hidden until `share.js` confirms the Web Share API exists.

### Links

Five variants, all built on the same idea: a link is either underlined or it is inside something that responds as a whole. `inline` is `slate-12` on a `slate-5` bottom border going ruby; `inline_accent` is ruby text that underlines on hover; `tag` and `post_tag` are mono `slate-10` going ruby; `action` and `section_action` are mono on a slate-5 rule with a nudging icon; `skip` is screen-reader-only until focused, then a bordered `slate-2` plate at the top left.

### Inputs / Fields

The command palette input is the only text input on the site: fully transparent, borderless, no outline, `15.5px` `slate-12` with a `slate-8` placeholder. It carries no chrome because the panel around it _is_ the field — a `slate-2` fill, a `slate-5` border, a 6px radius, and dividing rules above the results and below the hints. The native search clear button is suppressed: it renders as an unstyleable glyph and duplicates the `esc` cap beside it. Focus is implicit; the panel opening is the focus event.

### Navigation

Sticky, `64px` tall (`56px` below `compact`), `bg-slate-1/85` with `backdrop-blur backdrop-saturate-150`. The wordmark is the name at `15.5px` — one step above the nav links beside it, or the top-left has no anchor and reads as another nav item — with a `ruby-11` period, a `slate-8` slash, and `@andrewmcodes` in `11.5px` mono. Nav links are `13.5px` at `6px 10px` in `slate-11`, going `slate-12` on a `slate-3` fill; the active item carries a `1.5px` `ruby-11` bar inset 10px from each edge, the only always-visible ruby in the chrome besides the wordmark's period.

Below `820px` the links collapse into a hamburger opening a full-width drawer: `bg-slate-1/95 backdrop-blur`, a `slate-6` bottom border, `rounded-b-md`, over a `bg-slate-1/50 backdrop-blur-sm` scrim, with the header dropping its own translucency via `:has()`. Drawer items are `15px` at `12px 16px` with a 6px radius, and the active one gets a `ruby-3` fill with `ruby-11` text — the one place the accent is a background for navigation, because at that size a 1.5px underline wouldn't read. State is `data-open`, not `hidden`, so the transition can run, and the panel is `inert` while closed.

### Theme Toggle

A three-way `radiogroup` — system, light, dark — as `32px` circular buttons inside a `slate-3` pill. The selected one lifts to `slate-5` with a `slate-12` icon and a `shadow-sm`, driven entirely by `aria-checked:` variants so the accessible state and the visual state cannot drift apart. Focus is an inset `ruby-8` ring rather than the standard offset outline, because the buttons sit flush inside a track.

### Notes and Callouts

- **Note** (`slate-2` on a `slate-6` border, 12px radius, 16px padding) and its accent scheme (`ruby-3` on `ruby-6` with `ruby-12` text) — markdown-aware callouts inside prose.
- **Stale note** (`amber-500/5` wash, `amber-500/30` border, 8px radius, solid amber icon): raised above the article on posts whose last update is over two years old, unless the post is a CFP, marked `evergreen: true`, or opts out with `stale_alert: false`.

### Motion

Motion is short, small, and only ever a response to input. `transition-colors` at the Tailwind default (150ms) is the workhorse and covers nearly every state change in the system. There is exactly **one authored motion moment**: the command palette's panel drop — `translateY(-10px)` → `0` with opacity over `180ms cubic-bezier(.2, .8, .2, 1)`, its overlay fading in over `120ms`. Everything else is a nudge: the entry arrow slides in 4px on hover or focus, section-action and primary-button icons nudge 2px right, the back arrow nudges 2px left, the drawer chevron slides in 4px with opacity, and the drawer itself animates opacity and an 8px translate over `200ms ease-out`.

Cross-document view transitions run at `200ms`, armed by `<meta name="view-transition" content="same-origin">` in the root layout — without it Turbo Drive handles the navigation and the `@view-transition` rule is dead code. A global `prefers-reduced-motion` block reduces every animation, transition, and scroll behaviour to `0.01ms`, and then names `::view-transition-old(root)` / `::view-transition-new(root)` separately, because `*` does not match pseudo-elements and the cross-document fade would otherwise outlive the blanket rule.

### Named Rules

**The Focus-Guarantee Rule.** Keyboard focus is a system guarantee, not a per-component decision: one rule over `:where(a, button, input, select, textarea, summary, [tabindex]):focus-visible` gives every focusable element a `2px solid ruby-9` outline at `2px` offset with a `4px` radius. It lives in `@layer base` specifically so a component can still override it from markup — unlayered CSS outranks Tailwind's utilities whatever the specificity, so the theme toggle's inset ring and the palette's borderless input could not opt out. Inside `base`, a utility wins as expected. Never remove focus from a control; override the indicator if you must, and never chase focus component by component.

**The Inert-Until-Touched Rule.** Components have no colour, border, shadow, or decoration at rest beyond their hairline. Everything expressive — the ruby, the arrow, the tonal shift — is a hover, focus, or current state. A screenshot of this site at rest should look almost dead; using it should not.

**The Whole-Row Rule.** When a row or tile is a link, the entire region is the anchor and the entire region responds. Never a small "read more" inside an inert block. The one sanctioned alternative is an inert row that names several destinations as links, which is what a talk with both a video and slides gets.

**The Derived-Number Rule.** Any number the design displays must be derived from the collections or data at build time. The homepage ledger counts posts, repos, and talks from the resources themselves; the one constant, Remote Ruby's back catalogue, is stated conservatively as `350+` because the data file carries only the latest episode. A count that can go stale silently is worse than no count.

## Do's and Don'ts

### Do:

- **Do** reach for `Entry` for anything dated and `Tile` for anything genuinely parallel, and write a thin adapter component that maps your data onto one of them rather than a new primitive.
- **Do** hang apparatus in the 168px label rail — the section name, its one-line description, its "everything else" link — and leave the column beside it carrying only the work.
- **Do** spend ruby only on hover, focus, active, and current. The resting page should hold almost no ruby.
- **Do** use one of the fifteen named type roles for every size, and add a new role with its own leading, tracking, and weight rather than assembling one at a call site.
- **Do** put every measurement in Geist Mono, the reading column in Source Serif 4, and everything else in Archivo.
- **Do** author every new colour as a light/dark pair in `frontend/styles/index.css` and bridge it into `@theme` as `--color-<name>` in the same change.
- **Do** separate regions with a 1px `slate-6` hairline, and give hover states exactly one tonal step (`slate-1` → `slate-2`).
- **Do** underline links in prose. Colour is reinforcement, never the distinction.
- **Do** let the base focus rule do its job, and if a control genuinely needs a different indicator, override it from markup rather than removing it.
- **Do** derive any number the design displays from the collections or data at build time.

### Don't:

- **Don't** put dated content in a grid. Chronology is rows; a grid is for peers with no meaningful order.
- **Don't** add a solid ruby field at rest — including on the primary action. The measured fill failed contrast at 3.89:1 and read as a landing-page object; the hairline is the design, not a compromise.
- **Don't** add a second accent. A colour outside slate and ruby is admissible only as upstream data (GitHub's language colour), a borrowed semantic (amber for staleness), or a one-axis derived fallback (the podcast hue) — never as a choice made for its own sake.
- **Don't** generate a colour on more than one axis. The podcast hue rotates hue at fixed lightness and chroma; free a second axis and a family of shows becomes five unrelated colours.
- **Don't** put a kicker above a title. A show, a venue, an episode number, or a city is a fact about the item and belongs in the meta row.
- **Don't** put a shadow on anything that scrolls with the page. Even the palette and the drawer do without one; a border and a field are the elevation.
- **Don't** round content. Entry rows, tile cells, the ledger, and ruled sections are square.
- **Don't** make a section label large. Hierarchy comes from the rail, the rules, and the face — not from type size.
- **Don't** reference a Radix step `@theme` doesn't bridge; an unbridged utility fails silently rather than erroring.
- **Don't** open a second rail inside a rail, or inline apparatus into the content column on desktop.
- **Don't** add a `dark:` variant to fix a colour. If a token looks wrong in one theme, the pair in `index.css` is wrong.
- **Don't** ship a change verified in only one theme. Dark is where the work is composed; light is tested, not assumed.
- **Don't** drift toward the landing page: no accent field as a first object, no card grid as the default primitive, no decorated section headings, no stock cover images on rows.

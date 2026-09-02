---
name: andrewm.codes
description: The personal site of Andrew Mason — a quiet, exact reading surface built on sage paper, hairline rules, and a single mint accent.
colors:
  sage-1: "#fbfdfc"
  sage-2: "#f7f9f8"
  sage-3: "#eef1f0"
  sage-4: "#e6e9e8"
  sage-5: "#dfe2e0"
  sage-6: "#d7dad9"
  sage-7: "#cbcfcd"
  sage-8: "#b8bcba"
  sage-9: "#868e8b"
  sage-10: "#7c8481"
  sage-11: "#5f6563"
  sage-12: "#1a211e"
  mint-3: "#ddf9f2"
  mint-4: "#c8f4e9"
  mint-5: "#b3ecde"
  mint-6: "#9ce0d0"
  mint-8: "#4cbba5"
  mint-9: "#86ead4"
  mint-11: "#027864"
  mint-12: "#16433c"
  slate-3: "#f0f0f3"
  slate-6: "#d9d9e0"
  slate-11: "#60646c"
  slate-12: "#1c2024"
  warning: "oklch(0.769 0.188 70.08)"
typography:
  display:
    fontFamily: "Inter Variable, ui-sans-serif, system-ui, sans-serif"
    fontSize: "clamp(38px, 6.2vw, 68px)"
    fontWeight: 600
    lineHeight: 1.02
    letterSpacing: "-0.03em"
    fontFeature: "cv11, ss01"
  headline:
    fontFamily: "Inter Variable, ui-sans-serif, system-ui, sans-serif"
    fontSize: "clamp(28px, 4vw, 40px)"
    fontWeight: 700
    lineHeight: 1.15
    letterSpacing: "-0.025em"
  headline-page:
    fontFamily: "Inter Variable, ui-sans-serif, system-ui, sans-serif"
    fontSize: "30px"
    fontWeight: 600
    lineHeight: 1.2
    letterSpacing: "-0.025em"
  title:
    fontFamily: "Inter Variable, ui-sans-serif, system-ui, sans-serif"
    fontSize: "17px"
    fontWeight: 500
    lineHeight: 1.3
    letterSpacing: "-0.025em"
  row-title:
    fontFamily: "Inter Variable, ui-sans-serif, system-ui, sans-serif"
    fontSize: "15.5px"
    fontWeight: 500
    lineHeight: 1.375
    letterSpacing: "-0.008em"
  body:
    fontFamily: "Inter Variable, ui-sans-serif, system-ui, sans-serif"
    fontSize: "15px"
    fontWeight: 400
    lineHeight: 1.625
    letterSpacing: "normal"
  body-prose:
    fontFamily: "Inter Variable, ui-sans-serif, system-ui, sans-serif"
    fontSize: "16px"
    fontWeight: 400
    lineHeight: 1.7
    letterSpacing: "normal"
  label:
    fontFamily: "JetBrains Mono Variable, ui-monospace, Menlo, monospace"
    fontSize: "12px"
    fontWeight: 500
    lineHeight: 1.4
    letterSpacing: "0.08em"
  meta:
    fontFamily: "JetBrains Mono Variable, ui-monospace, Menlo, monospace"
    fontSize: "11.5px"
    fontWeight: 400
    lineHeight: 1.5
    letterSpacing: "normal"
  code:
    fontFamily: "JetBrains Mono Variable, ui-monospace, Menlo, monospace"
    fontSize: "13.5px"
    fontWeight: 400
    lineHeight: 1.5
    letterSpacing: "normal"
rounded:
  none: "0px"
  xs: "4px"
  md: "6px"
  lg: "8px"
  xl: "12px"
  tile: "10px"
  panel: "14px"
  2xl: "16px"
  full: "9999px"
spacing:
  row: "14px"
  row-lg: "20px"
  card: "20px"
  gutter: "36px"
  gutter-narrow: "32px"
  gutter-mobile: "16px"
  section: "56px"
  page-top: "64px"
  page-bottom: "96px"
components:
  button-primary:
    backgroundColor: "{colors.mint-4}"
    textColor: "{colors.mint-11}"
    typography: "{typography.body}"
    rounded: "{rounded.md}"
    padding: "10px 14px"
  button-primary-hover:
    backgroundColor: "{colors.mint-5}"
  button-secondary:
    backgroundColor: "{colors.sage-3}"
    textColor: "{colors.sage-12}"
    typography: "{typography.body}"
    rounded: "{rounded.md}"
    padding: "10px 14px"
  button-secondary-hover:
    backgroundColor: "{colors.sage-4}"
  button-ghost:
    backgroundColor: "transparent"
    textColor: "{colors.sage-11}"
    typography: "{typography.body}"
    rounded: "{rounded.md}"
    padding: "10px 14px"
  button-ghost-hover:
    backgroundColor: "{colors.sage-3}"
    textColor: "{colors.sage-12}"
  button-share:
    backgroundColor: "transparent"
    textColor: "{colors.sage-10}"
    typography: "{typography.meta}"
    rounded: "{rounded.none}"
    padding: "0 0 2px"
  button-share-hover:
    textColor: "{colors.mint-11}"
  nav-link:
    backgroundColor: "transparent"
    textColor: "{colors.sage-11}"
    rounded: "{rounded.md}"
    padding: "6px 10px"
  nav-link-active:
    textColor: "{colors.sage-12}"
  nav-link-drawer-active:
    backgroundColor: "{colors.mint-3}"
    textColor: "{colors.mint-11}"
    rounded: "{rounded.xl}"
    padding: "12px 16px"
  post-row:
    backgroundColor: "transparent"
    textColor: "{colors.sage-12}"
    typography: "{typography.row-title}"
    rounded: "{rounded.none}"
    padding: "14px 0"
  post-row-hover:
    textColor: "{colors.mint-11}"
  media-row:
    backgroundColor: "transparent"
    textColor: "{colors.sage-12}"
    typography: "{typography.title}"
    rounded: "{rounded.none}"
    padding: "20px 0"
  media-row-hover:
    backgroundColor: "{colors.sage-2}"
  project-card:
    backgroundColor: "{colors.sage-1}"
    textColor: "{colors.sage-11}"
    rounded: "{rounded.none}"
    padding: "{spacing.card}"
  project-card-hover:
    backgroundColor: "{colors.sage-2}"
  hero-index-row:
    backgroundColor: "transparent"
    textColor: "{colors.sage-12}"
    rounded: "{rounded.none}"
    padding: "10px 0"
  hero-index-row-hover:
    textColor: "{colors.mint-11}"
  tag-pill:
    backgroundColor: "transparent"
    textColor: "{colors.sage-11}"
    rounded: "{rounded.full}"
    padding: "2px 8px"
  tag-pill-hover:
    textColor: "{colors.mint-11}"
  status-chip:
    backgroundColor: "transparent"
    textColor: "{colors.sage-10}"
    rounded: "{rounded.full}"
    padding: "1px 6px"
  status-chip-active:
    backgroundColor: "{colors.mint-4}"
    textColor: "{colors.mint-11}"
    rounded: "{rounded.full}"
    padding: "1px 6px"
  input-search:
    backgroundColor: "transparent"
    textColor: "{colors.sage-12}"
    typography: "{typography.body}"
    rounded: "{rounded.none}"
    padding: "0px"
  kbd:
    backgroundColor: "{colors.sage-3}"
    textColor: "{colors.sage-11}"
    typography: "{typography.meta}"
    rounded: "{rounded.xs}"
    padding: "1px 6px"
  note:
    backgroundColor: "{colors.sage-2}"
    textColor: "{colors.sage-11}"
    rounded: "{rounded.xl}"
    padding: "16px"
  note-accent:
    backgroundColor: "{colors.mint-3}"
    textColor: "{colors.mint-12}"
    rounded: "{rounded.xl}"
    padding: "16px"
  note-warning:
    backgroundColor: "transparent"
    textColor: "{colors.sage-12}"
    rounded: "{rounded.lg}"
    padding: "16px"
  theme-toggle:
    backgroundColor: "{colors.sage-3}"
    textColor: "{colors.sage-10}"
    rounded: "{rounded.full}"
    padding: "4px"
  theme-toggle-active:
    backgroundColor: "{colors.sage-5}"
    textColor: "{colors.sage-12}"
    rounded: "{rounded.full}"
---

# Design System: andrewm.codes

## Overview

**Creative North Star: "The Engineer's Notebook"**

This is a working log kept in public, and it looks like one. Sage paper as the ground, hairline rules as the only structure, monospace in the margins for everything that is a fact — dates, tags, reading times, star counts, episode numbers, keyboard hints — and Inter in the body for everything that is a sentence. The split is the whole system: **mono is the record, sans is the voice.** A post row reads like a ledger line because it is one; a paragraph reads like writing because it is.

The mood is quiet, exact, and unhurried. Nothing raises its voice, and precision is the thing that signals care. There is exactly one brand accent in the palette, and it is spent almost entirely on hover and active states, which means the page at rest is a nearly monochrome field of sage with black text — and the instant a pointer lands, the thing under it turns mint. Restraint is not an absence of design here; it is the mechanism. A site that used five accent colors could not make a single hover feel like an event.

Surfaces are flat. Depth is a 1px line, not a shadow. Shadows exist, but only on the things that genuinely float above the page — the command palette, the mobile menu, the Markdown-actions dropdown — so their appearance is a real signal that context has changed rather than a decorative default. The confirmed anti-reference is the **generic dev-blog template**: a grid of cards with stock cover images, colored tag pills, `rounded-2xl` on everything, emoji section headers. The row-and-hairline list is the deliberate alternative to that, and the mono uppercase section label is the deliberate alternative to a decorated heading.

**Key Characteristics:**

- Two typefaces with strictly divided jobs: **Inter Variable** for prose, **JetBrains Mono Variable** for metadata and labels.
- A 12-step sage ramp carrying the entire interface, a mint ramp reserved almost entirely for state, and a cool slate ramp used only where content is quoted rather than authored.
- Hairline `1px` sage-4 borders as the universal separator; no ambient shadows on content.
- Dark and light are equal peers, defined as paired values on `[data-theme]` and resolved before first paint.
- Section headings are mono, uppercase, 12px, `0.08em` tracked — a filing label, not a title.
- Every interactive element is visually inert at rest and turns mint on hover.
- Evidence is displayed as a ledger, not asserted as a claim — the hero's index panel counts posts, repos, episodes, and talks from the collections at build time.

## Colors

A near-monochrome sage field with one green-teal brand accent, drawn from Radix UI Colors (Sage + Mint + Slate) and inlined as CSS custom properties in `frontend/styles/index.css` so they can be scoped to `[data-theme]` rather than Radix's own `.dark` class selectors. The `@radix-ui/colors` package is the source of truth for every step; values are copied from `node_modules/@radix-ui/colors/{sage,mint,slate}[-dark].css` rather than eyeballed.

Every sage, mint, and slate token is a **light/dark pair**. The frontmatter carries the light value as canonical; the dark counterpart for each is in `.impeccable/design.json` under `extensions.colorMeta`. The pairs are perceptually matched, not inverted — sage-11 is a mid-dark gray-green on paper and a mid-light gray-green on ink, and both read as "secondary text."

### Primary

- **Terminal Mint** (`mint-11`): the only brand accent in the system, and the single most important token in it. It carries link text in prose, every hover state on rows, cards, nav items, hero index rows, and footer links; the active-tab underline in the topbar; the show/venue line on episode and talk cards; the blockquote rule; the bullet-thread dot ring; and the heading-anchor hover. It is a deep pine-teal on paper and a bright aqua on ink — the phosphor green of a terminal, aged.
- **Mint Fill** (`mint-4`, hover `mint-5`): the primary button's background, the "active" project status chip, and `::selection`. The only place mint appears as a *surface* rather than as text, apart from the active drawer item.
- **Mint Wash** (`mint-3`): the accent callout background and the active item in the mobile drawer.
- **Mint Marker** (`mint-9`): the topbar's avatar dot and the `focus-visible` outline color. A pure, saturated statement used at ≤36px. `mint-8` is the theme toggle's focus ring; `mint-6` is the accent callout's border.
- **Mint Deep** (`mint-12`): text on mint-tinted surfaces — accent callout body, accent headings.

### Secondary

Slate is a **cool** neutral against sage's warm green-gray — the same lightness structure, a different temperature. It is the site's annotation voice: the places where something is being *shown* rather than *said*. The full 12-step ramp is bridged, but only four steps are in use.

- **Shell Grey** (`slate-3` fill, `slate-12` text): the `Command` block — a `$` prompt cap butted against a mono code span, both on the same fill with the radius split across the pair. A terminal quotation, and the one surface on the site that is deliberately not paper.
- **Frame Grey** (`slate-6`): the `1px` ring around a framed figure image, where a sage hairline would disappear into the page ground it sits on.
- **Caption Grey** (`slate-11`): figure caption text, sitting one temperature step off the body copy it explains.

### Neutral

- **Paper** (`sage-1`): the page ground and the resting background of project and featured cards. Also the fill behind the translucent topbar, the mobile drawer, and the bullet-thread dots.
- **Raised Paper** (`sage-2`): the command palette shell, the dropdown menu, the card hover state, and the plain-`<pre>` dev fallback. One tonal step, never more.
- **Control Fill** (`sage-3`): button secondary background, nav hover, inline `<code>` background, keyboard-cap fill, theme-toggle track.
- **Hairline** (`sage-4`): the universal 1px separator — row dividers, card-grid rules, section underlines, footer top border, inline-code borders, bullet-thread spine. The most structurally load-bearing color in the system.
- **Strong Rule** (`sage-5`): the heavier 1px — link underlines, panel borders, `<kbd>` outlines, the post-footer and related-posts rules, the theme toggle's selected pill. Used where a line must read as an edge rather than a divider.
- **Faint Ink** (`sage-7`, `sage-8`): placeholder text, the `#` before a tag, resting arrow glyphs, the resting heading anchor, the brand-lockup slash. The quietest things that are still legible.
- **Meta Ink** (`sage-10`): monospace metadata — star and fork counts, source notes, section-action links, back links, related-post dates. The mono voice's default color when it is *not* carrying primary information.
- **Body Ink** (`sage-11`): all body copy, all secondary text, prose paragraphs, and the mono metadata that sits directly under a title. Numerically the most-used token in the codebase.
- **Full Ink** (`sage-12`): headings, post titles, and any text that must win a scan.

### Functional (data-carrying, not brand)

Three colors originate outside the sage/mint system. None of them is a second brand accent; each one is doing a job that the accent physically cannot, because its *value* is the information.

- **Warning Amber** (Tailwind `amber-500`): the stale-post notice only — a `/30` border on a `/5` wash with a solid-amber icon. The single warning color on the site. It is allowed because "this content may be out of date" is a caution signal that mint, which means "live and under the pointer," would actively misreport.
- **Podcast hue** (`oklch(0.62 0.14 <hue>)`): the rounded mark tile on each podcast row, where `<hue>` comes from `accent_hue` in `src/_data/podcasts.yml` and inactive shows drop to `opacity: 0.7`. Fixed lightness and chroma with only the hue rotating keeps a row of shows reading as one family. It is a per-show identifier, not decoration.
- **Language dot** (upstream GitHub value): the 8px dot on a project card's detail row, taken from GitHub's own language colors so Ruby reads as Ruby. Falls back to `#701516`.

### Named Rules

**The One Voice Rule.** Mint has exactly one job: to mark what is live, active, or under the pointer. It never appears as decoration and never as a second brand color. At rest, a full viewport should contain almost no mint at all — often only the topbar dot, the period after "Andrew Mason", and a show name. Its rarity is what makes a hover legible from the corner of the eye.

**The Borrowed-Color Rule.** A color outside sage and mint is admissible only when the color *is* the data — a warning level, a per-show identifier, an upstream language color. Never invent a decorative color; only borrow one that means something. If a new color cannot answer "what fact does this encode?", it does not go in.

**The Both-Themes Rule.** No color is chosen for light and then checked in dark. Every token is authored as a pair in `frontend/styles/index.css` and both are first-class. A change that only looks right in one theme is not finished.

**The Bridge Rule.** A Radix step is only usable in markup if it has been bridged into `@theme` as `--color-<name>`. Using `bg-mint-7` when `--color-mint-7` isn't declared produces silence, not an error — the class simply does nothing and the element falls back to inherited color. Sage and slate are bridged in full; mint is bridged as a subset (steps 3, 4, 5, 6, 8, 9, 11, 12), so mint is where this bites. Add the bridge and the token in the same change, and never reference a step the theme block doesn't declare.

**The Two-Temperature Rule.** Sage is the page and slate is the annotation. Warm sage owns every surface the site speaks in — ground, chrome, hairlines, body text, rows, cards. Cool slate is admitted only where content is being displayed rather than authored: the shell-prompt block, a figure's frame and caption. Slate never separates two regions, never carries an interface control, and never sets body copy. If a new slate usage can't name the thing it is quoting, it should be sage.

## Typography

**Display / Body Font:** Inter Variable (with `ui-sans-serif, system-ui, sans-serif`), loaded via `@fontsource-variable/inter` and self-hosted. `font-feature-settings: "cv11", "ss01"` is set globally on `<body>` — the single-story `a` and the disambiguated `l`, which keeps small metadata legible.

**Label / Mono Font:** JetBrains Mono Variable (with `ui-monospace, Menlo, monospace`), via `@fontsource-variable/jetbrains-mono`.

**Character:** A neutral, high-legibility grotesque against a warm, wide-aperture developer mono. Neither typeface is doing anything expressive on its own — the expression comes entirely from *which one is used where*. Inter never appears in a metadata slot; JetBrains Mono never appears in a sentence.

### Hierarchy

- **Display** (600, `clamp(38px, 6.2vw, 68px)`, `1.02`, `-0.03em`): the homepage `<h1>` only. Tight tracking and sub-solid leading make a two-word name read as a mark rather than a sentence. Capped at `680px` and `text-balance`.
- **Headline** (700, `clamp(28px, 4vw, 40px)`, `1.15`, tight tracking): post titles. Heavier than Display because it sits above dense metadata and has to hold the top of the page alone.
- **Headline (page)** (600, `30px`, tight tracking): index and listing page titles via `Ui::PageHeader`. One weight and one step down from a post title — a listing is a room, not an argument.
- **Title** (500, `17px`, tight tracking): episode, talk, and podcast row headings. The largest type inside a list.
- **Row title** (500, `15.5px`, `1.375`, `-0.008em`): post-row and meta-row titles, and card names at `15px`. Deliberately close to body size, because the list is meant to be scanned as a body of work, not as a stack of headlines.
- **Body** (400, `15px`, `1.625`): the global default set on `<body>`. Interface copy, descriptions, nav. Supporting copy inside lists and cards runs `13.5px`–`14.5px` on `leading-snug`.
- **Body (prose)** (400, `16px`, `1.7`): article text only, via the `post` prose variant. One step larger and noticeably looser than interface body — the reading surface earns the extra room. Constrained to `max-w-prose` (~65ch) unless explicitly widened; free-standing hero and page copy caps at `62ch` or `600px`.
- **Label** (mono, 500, `12px`, uppercase, `0.08em`): section headings. This is the signature type treatment of the site. Sub-labels inside a page (collection groups, related posts, tag clouds) drop to `11–11.5px` at the same tracking.
- **Meta** (mono, 400, `11–12.5px`): dates, tags, reading times, star and fork counts, language names, episode numbers, keyboard caps, footer, post navigation, copy-code button.
- **Code** (mono, 400, `13.5px`): fenced code blocks, both Torchlight-highlighted and the plain dev fallback. Set below body prose (`16px`) on purpose — a wide code sample has to fit the measure without horizontal scroll before it has to match the text. Inline `<code>` is separate: it inherits its surrounding size at `0.875em` so it doesn't disturb the line it sits in.

### Named Rules

**The Mono-Is-Metadata Rule.** If it is a fact about the content — when, how long, how many, what tag, what key, which episode — it is JetBrains Mono. If it is the content, or a sentence about it, it is Inter. There is no third category and no overlap.

**The Label-Not-Title Rule.** Section headings are never large. `now`, `featured work`, `recent posts`, `index` are set at 12px mono uppercase in sage-11, sitting on a hairline — a filing tab, not a banner. Scale hierarchy is carried by the ruled structure and by which type family is used, not by making headings big.

**The Lowercase Rule.** Section labels are authored lowercase and rendered uppercase by CSS. Copy stays in the site's understated register: no title case in section headings, no exclamation points.

## Layout

A single centered column, one gutter, no sidebars. `PageShell` owns page width in two sizes: **wide** (`max-w-[1080px]`, `36px` gutter) for index and listing pages, and **narrow** (`max-w-[720px]`, `32px` gutter) for reading. Both collapse to a `16px` gutter below `768px`. The topbar and footer independently repeat the wide shell's `1080px / 36px` measurements so all three align to the same edge at every width.

Vertical rhythm is coarse and consistent: pages open at `64px` and close at `96px`; sections are separated by `56px`; homepage sections use a tighter `48px` because the hairlines already do the separating. One homepage section — the `now` block directly under the hero — uses a `home_coda` step (`8px` top, `80px` bottom) that binds it to the hero above and opens a large gap below, so the page reads as a peak followed by an even body rather than as six sections at identical pitch.

Rows come in three densities against a hairline: post and card rows at `14px` of vertical padding, podcast rows at `18px`, and episode/talk rows at `20px`. Dense enough that a year of writing fits in a scan, loose enough to stay a list rather than a table.

The post row is a three-column grid — `96px` (mono date) / `1fr` (title and tags) / `auto` (arrow) — baseline-aligned, collapsing to a single stacked column below `768px` where the date becomes an `11px` line above the title. Media rows use `120px / 1fr`; podcast rows use `64px / 1fr / auto`; the `now` list uses `92px / 1fr`.

The homepage hero is the one place where the page is two columns: a prose column beside a `300px` index panel, `64px` apart, collapsing to stacked at `nav` (820px). Everywhere else, responsiveness is a matter of gutters and where a grid collapses.

Breakpoints are Tailwind's defaults (`sm` 640, `md` 768, `lg` 1024) plus two named ones declared in `@theme` because they are load-bearing for the topbar and don't map onto the default scale: **`nav` at 820px** (primary nav collapses into the hamburger; the hero unstacks) and **`compact` at 520px** (the `@handle`, the "Search" word, and the ⌘K cap drop; header height goes `64px` → `56px`). Naming them keeps arbitrary `min-[820px]` values out of markup. The card grid has its own `680px` break where two columns become one.

### Named Rules

**The One-Column Rule.** Content is a single centered column at every width. There is no sidebar and no asymmetric page layout. The homepage hero is the single sanctioned exception: it may pair a prose column with one narrow ledger panel, and that pairing must collapse to stacked at `nav` (820px). Anywhere else, responsiveness is gutters, type scale, and grid collapse — never rearranging the page into a different shape.

## Elevation & Depth

**This system is flat.** Content surfaces have no shadow at any state. Separation is carried entirely by 1px hairlines (`sage-4`, occasionally `sage-5`) and by single-step tonal shifts (`sage-1` → `sage-2` on card hover). Cards are not boxes; they are regions bounded by rules, which is why the card grid draws its borders on the children rather than using a colored gap — an odd card count must not leave a filled cell behind.

Media rows get their hover surface from a `::before` pseudo-element inset `-12px` horizontally and `4px` vertically at `-z-10`, so the tint bleeds past the text without the row itself becoming a box.

Shadows appear on four elements, three of which are genuinely floating above the page in a modal sense, plus a hairline-scale shadow on buttons.

### Shadow Vocabulary

- **Command palette** (`box-shadow: 0 25px 50px -12px rgb(0 0 0 / 0.25)`): the ⌘K panel, which sits at `12vh` over a `bg-black/50 backdrop-blur-sm` scrim. The largest shadow in the system, used once.
- **Mobile menu** (`box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)`): the drawer that drops from the sticky header, with a matching `rounded-b-2xl`.
- **Dropdown** (`box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)`): the Markdown-actions menu on a post — the only non-modal popover, and the only place a shadow appears inside the reading column.
- **Control lift** (`box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1)`): primary and secondary buttons, and the selected theme-toggle pill. Just enough to read as pressable; not applied to ghost, text, or share variants.

Two non-shadow depth devices also carry weight: the topbar's `bg-sage-1/85 backdrop-blur backdrop-saturate-150`, which lets content pass under it as a translucent plate and drops to opaque via `:has()` while the mobile menu is open; and the bullet thread on the Now and Uses pages, where a 1px vertical `sage-4` line and 8px `mint-11`-ringed dots imply a spine without any elevation at all.

### Named Rules

**The Hairline-Not-Shadow Rule.** When two regions need separating, the answer is a 1px `sage-4` line. Reach for a shadow only when an element is floating — a modal, a drawer, or a popover, with a scrim or an outside-click dismissal. If it scrolls with the document, it is flat.

## Shapes

Radii are small, functional, and inconsistent by intent rather than by drift: **the more an element floats, the rounder it gets.** Content that sits in the document has no radius at all — post rows, card-grid cells, media rows, and section rules are square, because a hairline-ruled list has no corners to round. Controls are `6px` (`rounded-md`) — buttons, nav links, the topbar's icon buttons, the split Markdown-actions control, the media-row hover bleed. Small chips are `4px` (`rounded`) for keyboard caps and inline code, or fully pill (`rounded-full`) for tag links, status badges, the avatar dot, and the theme toggle, where the pill shape is what signals "this is a token, not a word." The stale note is `8px`; callouts and drawer items are `12px`; podcast mark tiles are a squircle-ish `10px`. The floating panels are the roundest things in the system: `14px` for the command palette and `16px` on the bottom corners of the mobile drawer.

Borders are always `1px` and always a sage step — never mint, never colored — with three exceptions, each of which is state or data: the primary button's `mint-9/40` edge, the accent callout's `mint-6`, and the active project chip's `mint-9/30`. The blockquote is the only heavy rule in the system: a `3px` `mint-11` left border, un-italicized, with `sage-12` text.

Icons are inline SVG at `15px` default (`14px` in chrome, `11–12px` in metadata rows and back links), `stroke-width: 2` (`1.8` on the back arrow), round caps and joins, `currentColor`. They inherit the accent on hover along with their text. GitHub-sourced glyphs (repo, star, fork) are filled rather than stroked at `11–14px`.

### Named Rules

**The Square-Content Rule.** Anything that scrolls with the page and is separated by a hairline is square. Radius is reserved for controls and for things that float.

## Components

### Buttons

- **Shape:** `6px` (`rounded-md`), or a full circle when `circle: true`. Five sizes from `xs` to `xl`; every size above `sm` uses the same `14px` text, so the scale is padding, not type.
- **Primary:** mint-tinted fill with mint-11 text and a translucent `mint-9/40` border (`bg-mint-4`, `padding: 10px 14px` at `xl`). The only filled-with-color control in the system, and the reason a homepage has exactly one obvious first action.
- **Secondary:** `sage-3` fill, `sage-12` text, no border. **Ghost:** transparent, `sage-11` text, `sage-3` on hover. **Text:** transparent with no hover surface at all.
- **Hover / Focus:** hover moves one tonal step (`mint-4` → `mint-5`, `sage-3` → `sage-4`). Focus is always `focus-visible:outline-2 outline-offset-2 outline-mint-9` — the same ring on every control, never removed.
- **Share:** a distinct variant that isn't a button shape at all — `11.5px` mono on a `sage-5` bottom border, going mint on hover. Behaves as ruled text, and is the same visual language as the `action` and `section_action` link variants.

### Post Row (signature component)

The core unit of the site and the clearest expression of the North Star. A three-column baseline-aligned grid — mono date, title with mono tag line, trailing arrow — on `14px` vertical padding above a `sage-4` hairline. At rest it is entirely sage: nothing is underlined, nothing is colored, nothing is boxed. On hover the whole row is the target: the title goes `mint-11` and the arrow goes mint and slides `0.5px` right. Below `768px` the grid collapses to one column and the date shrinks to `11px`. `MetaRow` is the same component generalized for talks, episodes, and links.

### Hero Index (signature component)

The ledger beside the homepage hero, and the site's answer to "prove it" without a claim. A mono `index` label on a hairline, then four rows — writing, open source, podcast, speaking — each a label/value pair split to the row edges above a `sage-4` rule, with counts derived from the collections at build time (`posts.resources.size`, `projects.resources.size`, `talks.size`) and the episode count stated conservatively as a constant. Label is `13.5px` Inter in `sage-12`, value is `11.5px` mono in `sage-11`; on hover both go `mint-11` together. Closes with a mono `11.5px` aside in the site's self-deprecating register.

**Any number shown here must be derived or verifiably true.** The ledger's whole value is that it cannot be padded.

### Cards / Containers

- **Corner style:** square. The grid draws hairlines with `border-top` on the container and `border-bottom` / `border-right` on the children so an odd card count can't leave a stray filled cell.
- **Background:** `sage-1` at rest, `sage-2` on hover — one tonal step, no shadow, no lift, no scale.
- **Internal padding:** `20px` at `md` and up; `14px` vertical with no horizontal padding below that, so cards flush to the page gutter on mobile.
- **Detail row:** every card ends with a mono `11.5px` footer of facts — language dot, stars, forks, or a kind label — pushed to the bottom with `mt-auto` so rows of unequal cards still align their baselines.
- **Status chip:** mono `10px` uppercase `0.06em` pill, `1px 6px`. `active` is mint-11 on `mint-4` with a `mint-9/30` border; anything else is `sage-10` on transparent with a `sage-4` border.

### Inputs / Fields

The command palette input is the only text input on the site: fully transparent, borderless, no outline, `15.5px` `sage-12` with a `sage-8` placeholder. It carries no chrome of its own because the panel around it — `sage-2` fill, `sage-5` border, `14px` radius, dividing rules above the results and below the hints — is the field. Focus is implicit; the panel opening *is* the focus event.

### Navigation

Sticky, `64px` tall, `bg-sage-1/85` with `backdrop-blur backdrop-saturate-150`. The brand lockup runs: a `36px` `mint-9` dot, the name in `14px` semibold `sage-12`, a `sage-8` slash, then `@andrewmcodes` in `12.5px` mono. Nav links are `13.5px` at `6px 10px`, `sage-11`, going `sage-12` on a `sage-3` fill. The active item is marked with a `1.5px` `mint-11` underline inset `10px` from each edge — the only always-visible mint in the chrome besides the dot.

Below `820px` the links collapse into a hamburger that opens a full-width drawer: `bg-sage-1/95`, `rounded-b-2xl`, `shadow-xl`, over a `bg-sage-1/50 backdrop-blur-sm` scrim, with the header dropping its own translucency via `header:has(#mobile-menu[data-open="true"])`. Drawer items are `15px` at `12px 16px` with `rounded-xl`, and the active one gets a `mint-3` fill with `mint-11` text — the one place the accent is a *background* for navigation, because at that size an underline wouldn't read. Menu state is `data-open`, not `hidden`, so the transition can run.

### Theme Toggle

A three-way `radiogroup` — system, light, dark — as `32px` circular buttons inside a `sage-3` pill. The selected one lifts to `sage-5` with `sage-12` icon and a `shadow-sm`, driven by `aria-checked:` variants so the accessible state and the visual state cannot drift apart. Focus is a `mint-8` ring rather than the standard `mint-9` outline, because the buttons sit flush inside a track.

### Motion

Motion is short, small, and only ever a response to input. `transition-colors` at the Tailwind default (`150ms`) is the workhorse and covers nearly every hover in the system — 48 occurrences against 5 of everything else. Arrows nudge `0.5px` on group hover; back arrows nudge `0.5px` left; drawer chevrons slide in from `-4px` with opacity. The command palette fades its overlay in over `120ms` and drops its panel `10px` over `180ms` on `cubic-bezier(.2, .8, .2, 1)`. The mobile drawer and its scrim animate opacity and an `8px` translate over `200ms ease-out`. Cross-document view transitions run at `200ms`. A global `prefers-reduced-motion` block reduces every animation, transition, and scroll behavior to `0.01ms`.

### Named Rules

**The Inert-Until-Touched Rule.** Components have no color, border, shadow, or decoration at rest beyond their hairline. Everything expressive — the mint, the nudge, the tonal shift — is a hover, focus, or active state. A screenshot of this site at rest should look almost dead; using it should not.

**The Whole-Row Rule.** When a row or card is a link, the entire region is the anchor and the entire region responds. Never a small "read more" link inside an inert block.

## Do's and Don'ts

### Do:

- **Do** put every fact in JetBrains Mono and every sentence in Inter. Dates, tags, reading times, counts, episode numbers, keyboard caps, and section labels are mono; body copy, titles, and descriptions are Inter.
- **Do** separate regions with a `1px` `sage-4` hairline, and give hover states exactly one tonal step (`sage-1` → `sage-2`, `mint-4` → `mint-5`).
- **Do** author every new color as a light/dark pair in `frontend/styles/index.css` and bridge it into `@theme` as `--color-<name>` before using it in markup.
- **Do** set section headings as `12px` mono uppercase `0.08em` `sage-11` on a hairline, with lowercase source copy.
- **Do** use `focus-visible:outline-2 outline-offset-2 outline-mint-9` on every interactive element, and make the whole row or card the target when it links somewhere.
- **Do** derive any number the design displays from the collections or data at build time. A count that can go stale silently is worse than no count.

### Don't:

- **Don't** add a second brand accent. Mint-11 is the only one, and it is spent on state. A color from outside sage/mint is admissible only when it encodes data — a warning level, a per-show hue, an upstream language color.
- **Don't** put a shadow on anything that scrolls with the page. Shadows belong to the command palette, the mobile drawer, the Markdown-actions popover, and buttons — nothing else.
- **Don't** round content. Post rows, media rows, card cells, and ruled sections are square; radius is for controls and floating panels.
- **Don't** make a section heading large. Hierarchy comes from the mono/sans split and the ruled structure, not from type size.
- **Don't** reference a Radix step that `@theme` doesn't bridge — an unbridged class fails silently. Sage and slate are complete; mint is a subset, so bridge the step in the same change that uses it.
- **Don't** let slate leak past annotation surfaces. Hairlines, chrome, controls, and body copy are sage; slate is for the shell block, the figure frame, and the caption.
- **Don't** split the page into columns outside the homepage hero. No sidebars, no two-up article layouts, no asymmetric listing pages.
- **Don't** drift toward the generic dev-blog template: no stock cover images on post cards, no colored tag pills, no `rounded-2xl` content boxes, no emoji section headers.
- **Don't** ship a change verified in only one theme. Both are first-class and both are resolved before first paint.

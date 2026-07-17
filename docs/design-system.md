# Design System

This site is built from ViewComponent-style components in `src/_components`,
styled with Tailwind v4 and the Radix UI Colors **Sage** (neutral) and **Mint**
(accent) scales. Page templates should **compose components instead of writing
page-local HTML and Tailwind**. Raw utility classes belong inside components,
where they can be named, documented, and reused.

The source of truth is the code, not this file: design tokens live in
`src/_components/base.rb`, color and theme primitives in
`frontend/styles/index.css`, and the global document shell in
`src/_layouts/default.erb`. This doc describes how those pieces fit together.

## Stack

- **Tailwind v4** (`@import "tailwindcss"`) with `@tailwindcss/typography` and
  `@tailwindcss/aspect-ratio`.
- **Radix UI Colors** Sage + Mint (`@radix-ui/colors`), values inlined as CSS
  custom properties (see [Color](#color)).
- **Fonts**: Inter Variable (sans) and JetBrains Mono Variable (mono), via
  `@fontsource-variable/*`.
- **Components**: Bridgetown's built-in `Bridgetown::Component` + sidecar `.erb`
  templates. The project does **not** load `bridgetown-view-component`.

---

## Foundations

### Color

Two 12-step Radix scales carry the entire palette:

- **Sage** — the neutral/gray scale: backgrounds, borders, body text.
- **Mint** — the brand/accent scale: links, focus rings, highlights.

Values are **inlined** in `frontend/styles/index.css` (we don't import Radix's
own CSS) and scoped to `:root, [data-theme="light"]` and `[data-theme="dark"]`,
so they track our attribute-based theme switch. They're exposed to Tailwind via
`@theme` as `--color-sage-N` / `--color-mint-N`, which generates the usual
utilities: `bg-sage-1`, `text-sage-12`, `border-sage-5`, `text-mint-11`, etc.

> **Only a subset of Mint steps are exposed as utilities.** Sage `1–12` are all
> available; Mint is limited to **3, 4, 5, 8, 9, 11, 12**. If you need another
> Mint step (e.g. `mint-6`), add a `--color-mint-6: var(--mint-6);` line to the
> `@theme` block first — the CSS variable exists, but the utility won't until
> it's mapped.

#### The 12-step scale (Radix semantics)

Each step has a consistent job across both scales. Reach for the step by its
role, not its number:

| Step | Role                       | Typical use here                                    |
| ---- | -------------------------- | --------------------------------------------------- |
| 1    | App background             | `bg-sage-1` (page background)                       |
| 2    | Subtle background          | cards, menus, `<pre>` fallback                      |
| 3    | UI element background      | code chips, secondary buttons, toggle track         |
| 4    | Hovered UI background      | hover state for step-3 surfaces                     |
| 5    | Active/selected background | selection, active toggle, hairline borders          |
| 6    | Subtle border / separator  | `border-sage-4`–`6` hairlines                       |
| 7    | UI border, focus ring      | heading-anchor color                                |
| 8    | Hovered border             | —                                                   |
| 9    | Solid background           | `mint-9` solid accent, focus outline, bullets       |
| 10   | Hovered solid              | —                                                   |
| 11   | Low-contrast text          | muted text (`text-sage-11`), links (`text-mint-11`) |
| 12   | High-contrast text         | body & headings (`text-sage-12`), strong accent     |

#### Sage (light / dark hex)

| Step    | Light     | Dark      |
| ------- | --------- | --------- |
| sage-1  | `#fbfdfc` | `#101211` |
| sage-2  | `#f7f9f8` | `#171918` |
| sage-3  | `#eef1f0` | `#202221` |
| sage-4  | `#e6e9e8` | `#272a29` |
| sage-5  | `#dfe2e0` | `#2e3130` |
| sage-6  | `#d7dad9` | `#373b39` |
| sage-7  | `#cbcfcd` | `#444947` |
| sage-8  | `#b8bcba` | `#5b625f` |
| sage-9  | `#868e8b` | `#63706b` |
| sage-10 | `#7c8481` | `#717d79` |
| sage-11 | `#5f6563` | `#adb5b2` |
| sage-12 | `#1a211e` | `#eceeed` |

#### Mint (light / dark hex) — ✓ = exposed as a Tailwind utility

| Step    | Light     | Dark      | Utility                 |
| ------- | --------- | --------- | ----------------------- |
| mint-1  | `#f9fefd` | `#0e1515` |                         |
| mint-2  | `#f2fbf9` | `#0f1b1b` |                         |
| mint-3  | `#ddf9f2` | `#092c2b` | ✓                       |
| mint-4  | `#c8f4e9` | `#003a38` | ✓                       |
| mint-5  | `#b3ecde` | `#004744` | ✓                       |
| mint-6  | `#9ce0d0` | `#105650` |                         |
| mint-7  | `#7ecfbd` | `#1e685f` |                         |
| mint-8  | `#4cbba5` | `#277f70` | ✓                       |
| mint-9  | `#86ead4` | `#86ead4` | ✓                       |
| mint-10 | `#7de0cb` | `#a8f5e5` |                         |
| mint-11 | `#027864` | `#58d5ba` | ✓ (accent text / links) |
| mint-12 | `#16433c` | `#c4f5e1` | ✓ (strong accent)       |

`mint-9` is intentionally the same bright value in both themes (it's a "solid"
step). Accent **text** uses `mint-11`, which is tuned for contrast in each mode.

Text selection is `mint-5` background on `sage-12` text.

### Typography

- **Sans** — `--font-sans` → `"Inter Variable", ui-sans-serif, system-ui` →
  `font-sans`. The default for body and headings.
- **Mono** — `--font-mono` → `"JetBrains Mono Variable", ui-monospace, Menlo` →
  `font-mono`. Used for metadata, tags, code, and "action" links.
- Body baseline (set in `default.erb`): `font-sans text-[15px] leading-relaxed`,
  with `font-feature-settings: "cv11", "ss01"` and antialiasing.

Type sizing flows through the [`Text`](#text) and [`Heading`](#heading) atoms
using the token maps below, rather than ad-hoc `text-*` classes. Long-form
markdown is wrapped in [`Prose`](#prose).

### Spacing & layout

Layout is owned by primitives, not page templates:

- [`PageShell`](#pageshell) — top-level page width + vertical rhythm.
- [`Stack`](#stack) — vertical flow with a `gap` token.
- `PageSection`, `CardGrid`, `CollectionGroup`, `MainContent` — section-level
  structure.
- `Container` — **legacy** responsive container; prefer `PageShell`.

Two non-Tailwind layout helpers live in CSS: `.card-grid` (a 2-up hairline grid
that collapses to 1 column under 680px) and `.bullet-thread` (the vertical
timeline used on Now/Uses).

### Breakpoints

Standard Tailwind `sm:` / `md:` / `lg:` plus two **named** breakpoints for the
topbar's nav-collapse points (declared in `@theme`):

| Variant                     | Width   | Purpose              |
| --------------------------- | ------- | -------------------- |
| `nav:` / `max-nav:`         | `820px` | primary nav collapse |
| `compact:` / `max-compact:` | `520px` | compact nav state    |

**Prefer `sm:` / `md:` / `lg:` over arbitrary `min-[Npx]:` / `max-[Npx]:`
values.** Only introduce a named breakpoint (in `@theme`) when a real collapse
point doesn't map onto the standard scale.

### Theming (light / dark)

- The active theme is the `data-theme="light|dark"` attribute on `<html>`.
- A tiny **pre-paint inline script** in `default.erb` sets it before first
  paint, reading `localStorage.theme` (only `"light"`/`"dark"` are persisted) or
  falling back to `prefers-color-scheme`.
- The [`ThemeToggle`](#themetoggle) is a 3-way `radiogroup`: **System / Light /
  Dark**. Choosing System clears the saved value and re-derives from the OS.
- `dark:` utilities are wired with `@custom-variant dark (&:where([data-theme="dark"], [data-theme="dark"] *))`.
- `<meta name="theme-color">` is emitted per color-scheme using
  `site.metadata.theme_color` (dark) and `theme_color_light` (light).

### Motion

- Cross-document **view transitions** are enabled (`@view-transition`), 200ms.
- All animation/transition is neutralized under
  `@media (prefers-reduced-motion: reduce)` — keep new motion CSS compatible.

---

## Design tokens

These maps live on `Base` (`src/_components/base.rb`) and on individual atoms.
**Use the token, not the raw class** — that's what keeps treatments consistent.

### `Base` — shared typography tokens

`TEXT_WEIGHT`

| Token       | Class            |
| ----------- | ---------------- |
| `default`   | `font-normal`    |
| `medium`    | `font-medium`    |
| `semibold`  | `font-semibold`  |
| `bold`      | `font-bold`      |
| `extrabold` | `font-extrabold` |
| `black`     | `font-black`     |

`TEXT_SIZES`

| Token  | Class       |
| ------ | ----------- |
| `none` | —           |
| `sm`   | `text-xs`   |
| `md`   | `text-sm`   |
| `lg`   | `text-base` |
| `xl`   | `text-lg`   |

`TEXT_SCHEME`

| Token                | Class          |
| -------------------- | -------------- |
| `default`            | —              |
| `muted`              | `text-sage-11` |
| `primary` / `accent` | `text-mint-11` |
| `strong`             | `text-sage-12` |

`HEADING_SIZES`

| Token | Class                  |
| ----- | ---------------------- |
| `xl`  | `text-4xl lg:text-5xl` |
| `lg`  | `text-3xl`             |
| `md`  | `text-base`            |
| `sm`  | `text-sm`              |

`HEADING_SCHEME`

| Token     | Class          |
| --------- | -------------- |
| `default` | `text-sage-12` |
| `muted`   | `text-sage-11` |
| `accent`  | `text-mint-12` |

`FONT_FAMILY`: `sans` → `font-sans`, `mono` → `font-mono`.

### Layout tokens

`Stack#GAPS`: `none` · `xs` (`gap-1`) · `sm` (`gap-2`) · `md` (`gap-4`) ·
`lg` (`gap-6`).

`PageShell#WIDTHS`: `wide` (`max-w-[1080px] px-9 max-md:px-4`) ·
`narrow` (`max-w-[720px] px-8 max-md:px-4`).
`PageShell#SPACING`: `default` (`py-16 pb-24`) · `home` · `none`.

---

## Components

Components are organized in three layers. **Edit pages by composing these**;
add a new component when a pattern recurs.

- **Layout** — `PageShell`, `PageSection`, `Stack`, `CardGrid`,
  `CollectionGroup`, `MainContent`. Own spacing, width, and document structure.
- **Atoms** — `Link`, `Button`, `Text`, `Heading`, `Icon`, `Image`, `Prose`,
  `MarkdownActions`, `ThemeToggle`, `ShareButton`. Own small reusable treatments
  and token variants.
- **Composition** — `Ui::PageHeader`, `SectionHead`, `HomeHero`, `PostHeader`,
  `PostFooter`, plus rows and cards. Combine atoms/layouts around
  content-specific data.

### Architecture: `Base` → `Box`

Most atoms inherit `Base` (tokens + the option pipeline) and usually `Box` (tag
rendering). The pattern:

- `COMPONENT_OPTIONS` — option keys consumed by the component; everything else
  in `**opts` passes through as HTML attributes.
- `INVALID_ATTRIBUTES` (`:as`, `:classes`, `:class_name`) — stripped from the
  passthrough.
- Override `classes` to set the component's default Tailwind classes (compose
  with `cx(...)`).
- Override `tag_opts` to inject element-specific attributes.
- `:as` picks the rendered tag (`Box`); `:class`/`:class_name` append to
  `classes`.
- Helpers: `cx(*classes)` concatenates, `slugify(str)` for ids.

```erb
<%= render Heading.new(size: :lg, scheme: :accent, as: :h1) do %>
  Section title
<% end %>

<%= render Text.new(scheme: :muted, size: :md) do %>
  Supporting copy.
<% end %>
```

### Button

`variant` × `size`, optional `circle`, renders `<a>` when given `href`.

- **Variants**: `primary` (mint), `secondary` (sage, default), `ghost`,
  `text`, `share` (mono underline action).
- **Sizes**: `xs` · `sm` · `md` (default) · `lg` · `xl`.

```erb
<%= render Button.new(variant: :primary, size: :lg, href: "/about/") do %>
  Read more
<% end %>
```

### Link

`Link` handles internal vs external (`http(s)` not matching `site.config.url`
gets `target="_blank" rel="noreferrer"`). Variants:

`default` · `nav` · `inline` · `inline_accent` · `tag` · `post_tag` ·
`action` · `section_action` · `post_nav` · `skip`.

Also accepts `scheme` (`TEXT_SCHEME`) and `weight` (`TEXT_WEIGHT`).

### Text

`<p>` by default. Options: `size`, `weight`, `scheme`, `font`, `truncate`,
`variant` (`default` · `source_note`).

### Heading

`<h2>` by default. Options: `size`, `weight` (defaults `semibold`), `scheme`,
`id`. Auto-generates an `id` from its content via `slugify` when none is given.

### Prose

Wraps rendered markdown. Built on `prose prose-sage dark:prose-invert` with
mint links and sage code chips. Options:

- `size`: `default` (`prose-base`) · `lg` (`prose-xl`).
- `variant`: `default` · `page` · `post` (post tunes 16px/1.7 line-height,
  heading rhythm, and mint blockquote rule).
- `max_w`: falsy keeps `max-w-prose`; pass truthy to remove the measure cap.

### Stack

`flex flex-col` with a `gap` token. Use for repeated rows that should share a
column rhythm without page-local classes.

### PageShell

Top-level page wrapper: `width` (`wide`/`narrow`) + `spacing`, centered with
`mx-auto w-full`. Start every page layout with a `PageShell`.

### Icon

Inlines SVGs from `src/images/<name>.svg` (via `bridgetown-svg-inliner`), with a
fallback to `external.svg` if the name is missing. Sizes: `sm` (16) ·
`default` (15) · `lg` (24) · `xl` (48). Pass `class:` to override dimensions.

### MarkdownActions

The "Copy page / View as Markdown" control on posts (the `.md` twin, plus
"Open in Claude/ChatGPT" deep links). Backed by `Builders::MarkdownSource` and
`frontend/javascript/copy_page.js`.

### ThemeToggle

3-way System/Light/Dark `radiogroup` (see [Theming](#theming-light--dark)).
Behavior is in `frontend/javascript/theme.js`.

---

## Code & syntax highlighting

- Fenced code blocks are highlighted with Bridgetown/Rouge
  (`.highlighter-rouge .highlight pre.highlight`, 13.5px code).
- Non-highlighted `<pre><code>` blocks use a matching sage fallback style.
- Inline `<code>` inside prose renders as a sage chip
  (`bg-sage-3`, `border-sage-5`, rounded).
- Every `<pre><code>` gets a JS-driven **Copy** button (`button.copy-code`).

---

## Conventions & rules

- Keep using Bridgetown's `Bridgetown::Component` + sidecar-template pattern
  unless the repo adds `bridgetown-view-component` (it currently does not).
- **Use layout components first** when editing a page. Add a new layout
  component when a spacing/grid pattern appears in more than one place.
- **Use atom variants before adding a one-off** link, text, or button class. If
  a new treatment is needed, add a token/variant rather than inline classes.
- Keep Tailwind classes **out of page templates** except the global document
  shell in `default.erb`.
- Reach for color steps **by role** (see the scale table), and prefer the
  semantic schemes (`muted`/`strong`/`accent`) over raw `text-sage-*`.
- Prefer `sm:`/`md:`/`lg:` over arbitrary `min-[Npx]:`/`max-[Npx]:`; only add a
  named breakpoint in `@theme` for a genuine collapse point.
- Add YARD comments to every component class and initializer option so the API
  is discoverable from source.
- Use `content` for default component blocks and `render?` for components that
  should conditionally skip output.
- Prefer component block content over passing HTML strings. Reserve
  `description_html`, `raw`, `safe`, and `<%==` for vetted JSON/metadata or
  trusted markup where escaping has been considered explicitly.
- Use `html_attributes` for composed attribute hashes; `Base`, `Box`, `Button`,
  `Image`, and `Link` centralize that pattern.
- Run `mise run format` before committing (StandardRB, `erb-format`, Prettier).

## See also

- `CLAUDE.md` / `AGENTS.md` — architecture and build pipeline.
- `frontend/styles/index.css` — color variables, `@theme`, global CSS.
- `src/_components/base.rb` — the token maps.
- `src/_layouts/default.erb` — document shell, theme script, fonts.

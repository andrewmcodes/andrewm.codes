# Design system

The site uses Bridgetown's built-in `Bridgetown::Component` with ERB sidecars, Tailwind v4, and Radix Mauve and Ruby. Compose pages from the components in `src/_components`.

## Sources of truth

- `frontend/styles/tailwind.css`: color values, type roles, breakpoints, prose, and interaction styling.
- `src/_components/base.rb`: semantic type, tone, weight, alignment, and spacing maps.
- `src/_components/main_content.erb`: content pane and gutters.
- `src/_layouts/default.erb`: document shell and pre-paint theme detection.
- `frontend/styles/index.css`: font imports bundled by esbuild.

Tailwind is built separately by `bin/tailwindcss`. Its explicit sources include frontend, config, plugins, and src. Keep utility names complete and scan-visible.

## Color and type

Mauve supplies backgrounds, borders, and text. Ruby identifies links and active interactions. Amber is reserved for notices; syntax highlighting has semantic colors. Values switch through `data-theme`.

Use `Base::TONE`: neutral for primary text, secondary for supporting text, accent for Ruby, and faint for icons only. Faint is unsuitable for small text. Inline links need an underline; color alone does not distinguish them.

Geist Sans sets sentences and interface text; Geist Mono sets metadata and code. `Text` uses `Base::TEXT_SIZES`; `Heading` uses `Base::HEADING_SIZES`. Roles include micro, meta, label, note, body, row, read, lead, headline, and display. Prefer roles to raw font sizes. Reading text is 17.5px with a 1.75 line height.

## Layout and spacing

The source rail appears at `shell`, 1024px. Below it, navigation uses a sticky bar and modal drawer. The pane is at most 46rem (736px). Prose text is limited to 38rem (608px); code, figures, and tables can use the full pane.

`PageShell` owns page spacing; `Stack` owns gaps. Space tokens are xxs (4px), xs (8px), sm (12px), md (16px), lg (24px), xl (32px), xxl (48px), xxxl (56px), and gutter (112px). Home uses a 56px hero-to-content gap below sm, retaining 112px on larger screens.

Use `Entry` for chronological lists and `Tile` inside `CardGrid` for peers. CardGrid declares grid utilities directly: two columns from 680px, one below. Its 40px column gap leaves 8px between tiles' 16px hover outsets. No dividing rules. Grid children allow long text to wrap.

## Components and interaction

- Base handles tokens and HTML options; Box renders tags and captured content. Use ERB do blocks for visible component content.
- PageSection supplies a label, description/link, and optional section ID.
- CollectionGroup labels archive years.
- ArchiveFilter provides text filtering plus project language, stars, and activity controls. Its full layout and initial count render with the page to prevent layout shift. The fieldset stays disabled until event handlers are attached. Without JavaScript, an explanation accompanies the disabled controls and the full archive remains visible. A live status reports counts; Clear filters restores all items.
- SectionIndex builds a labelled jump control from rendered headings. Go activates the selection, avoiding unexpected focus movement while choosing an option.
- Prose owns long-form typography. Contents reports a section count and remembers the reader's choice.
- Link owns inline, accent, navigation, tag, and action treatments. External links use noreferrer.
- ThemeToggle is a System/Light/Dark radio group. Mobile targets are at least 44px; desktop theme buttons remain compact.

The command palette has a labelled dialog, combobox, and listbox. Compact screens stack result kinds above wrapping titles and show a Close button. Keyboard guidance is hidden for compact screens and coarse pointers. The search page shows topics, destinations, and recent writing before a query.

## Accessibility and motion

Preserve the skip link, visible focus, dialog focus trapping/restoration, and labelled icon controls. Mobile navigation, search, social links, and theme controls use 44px targets. Muted text uses Mauve 11 in both themes. Hidden filtered items and empty year groups leave both layout and the accessibility tree.

Cross-document transitions last 180ms. Reduced-motion rules neutralize animation and smooth scrolling. Heading destinations clear the sticky mobile bar.

## Verification

Run mise run test, Ruby lint, and JS type checks for shared behavior changes. Run mise run build to verify production CSS and static output. Check Home and Projects at 1440, 1024, 680, 390, and 320px in both themes. Exercise filters, zero results, reset, keyboard search, touch close, and recovery links. Pair browser accessibility checks with visual inspection.

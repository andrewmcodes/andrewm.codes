# PRD — Static Open Graph Image Generation for Bridgetown

## Overview

Implement deterministic, build-time generated Open Graph images for a static Bridgetown site deployed to Cloudflare Workers Static Assets.

The system should:

- Generate one OG image per page/post during builds
- Produce static PNG assets
- Integrate cleanly into Bridgetown’s build lifecycle
- Avoid runtime infrastructure entirely
- Require no third-party image services
- Be cache-friendly and CDN-optimized
- Support future visual customization
- Be AI-agent-friendly for implementation

The architecture intentionally avoids:

- Runtime image generation
- Vercel deployment requirements
- Cloudflare Functions
- External media transformation services
- Database dependencies

## Goals

- Generate high-quality OG images automatically
- Keep infrastructure fully static
- Minimize operational complexity
- Ensure compatibility with:
  - Twitter/X
  - LinkedIn
  - Discord
  - Slack
  - Facebook
  - Google Discover
- Allow future template expansion
- Keep generation deterministic and reproducible

## Non-Goals

- Personalized images
- Request-time rendering
- User-uploaded image composition
- Dynamic statistics
- AI-generated art
- CMS-driven visual editing
- Video/social story formats

## Technical Stack

### Existing stack

- Bridgetown
- Ruby
- GitHub
- Cloudflare Pages

### New tooling

- Node.js 22+
- `satori`
- `@resvg/resvg-js`
- `glob`
- `node-html-parser`

### Why this stack

- Satori provides JSX-like declarative layout
- Resvg produces fast, deterministic PNG output
- Same rendering primitives as `@vercel/og`
- No browser dependency
- No Chromium/Puppeteer overhead
- Works inside CI environments reliably

## Architecture

```text
Bridgetown Build
  ↓
Generated HTML
  ↓
OG Generator Script
  ↓
Extract Final Metadata
  ↓
Render SVG via Satori
  ↓
Convert SVG → PNG via Resvg
  ↓
Write Static Assets
  ↓
Deploy to Cloudflare Pages
```

## Directory Structure

```text
.
├── scripts/
│   └── generate-og.mjs
├── src/
│   ├── _partials/
│   │   └── head.erb
│   ├── _data/
│   │   └── site_metadata.rb
│   └── assets/
│       ├── fonts/
│       │   └── Inter-Bold.ttf
│       └── og/
│           ├── backgrounds/
│           ├── logos/
│           └── templates/
├── output/
│   └── og/
│       ├── home.png
│       └── posts/
│           └── my-post.png
└── package.json
```

## Functional Requirements

### Page Metadata

Every renderable page must expose:

- title
- description
- canonical URL

Fallback hierarchy:

```text
Page title
  → Collection defaults
  → Site title
```

```text
Page description
  → Collection defaults
  → Site tagline
```

## OG Image Generation

### Generation Timing

Images must generate:

- After Bridgetown site build
- Before deployment

### Generation Inputs

Generator should consume:

- Final rendered HTML
- Not raw frontmatter

### Why

Benefits:

- Uses final computed metadata
- Avoids duplicated logic
- Compatible with:
  - Liquid
  - ERB
  - plugins
  - computed collections
  - future metadata systems

## Image Specifications

### Dimensions

- 1200×630 PNG

### Format

- PNG
- RGB
- Non-transparent

### File Size Target

- Under 300 KB preferred
- Hard limit:
  - 8 MB absolute max

### Visual Style

Design priorities:

- High readability
- Minimalism
- Strong typography
- Dark-mode-friendly
- Consistent branding

## Initial Template Design

### Layout

```text
┌────────────────────────────┐
│                            │
│  Site Name                 │
│                            │
│  Large Title               │
│                            │
│  Description excerpt       │
│                            │
└────────────────────────────┘
```

### Typography

- Inter
- Geist acceptable later

### Styling

- Gradient background
- Large title text
- Muted description
- Strong whitespace usage

## URL Strategy

### Deterministic Paths

```text
/og/home.png
/og/posts/my-post.png
/og/projects/my-project.png
```

### Rules

- One image per canonical page
- Stable paths
- No query params
- No runtime transformations

## HTML Metadata Requirements

Each page must include:

```html
<meta property="og:title" />
<meta property="og:type" />
<meta property="og:url" />
<meta property="og:image" />
<meta property="og:image:secure_url" />
<meta property="og:image:width" />
<meta property="og:image:height" />
<meta property="og:image:alt" />

<meta name="twitter:card" content="summary_large_image" />
<meta name="robots" content="max-image-preview:large" />
```

## Rendering Engine Requirements

### Satori Usage

Must support:

- Flexbox layouts
- Custom fonts
- Text truncation
- Background gradients
- SVG generation

### Avoid

- CSS Grid
- Browser-specific CSS
- Unsupported layout primitives

## Generator Script Requirements

### Responsibilities

- Scan generated HTML
- Extract metadata
- Build render payloads
- Render SVG
- Convert PNG
- Write output files
- Skip unchanged renders optionally

### Failure Handling

Build should fail if:

- Rendering throws
- Fonts missing
- Output write fails

Warnings only for:

- Missing description
- Missing title fallback usage

## Caching Strategy

### CDN Caching

Generated images should use:

```text
Cache-Control: public, max-age=31536000, immutable
```

### Invalidation Strategy

Preferred:

- Regenerate identical paths on deploy
- Cloudflare deployment invalidates naturally

Optional future enhancement:

- Content-hashed filenames

## CI/CD Requirements

### GitHub Actions

Pipeline should:

- Install Ruby dependencies
- Install Node dependencies
- Build Bridgetown
- Generate OG images
- Deploy output directory

### Node Version

- Node 22+

### Ruby Version

- Match production Bridgetown runtime

## Performance Requirements

### Build Performance

Target:

- <100ms render time per image

### Scalability

Must support:

- Hundreds of pages
- Without runtime degradation

## Accessibility Requirements

### Alt Text

Every page must emit:

```text
og:image:alt
```

### Typography

- High contrast
- Large readable title sizes

## Security Requirements

### No User Input

System should not:

- Accept runtime parameters
- Render arbitrary HTML
- Expose transformation endpoints

### Font Safety

Fonts should be:

- Local
- Version-controlled
- Deterministic

## Observability

### Logging

Generator should log:

- Render count
- Duration
- Failures
- Missing metadata warnings

### Future Optional Metrics

- Largest generated file
- Average render duration
- Cache hit estimation

## Future Enhancements

### Possible Future Features

- Per-collection themes
- Syntax-highlighted code cards
- Author avatars
- Dynamic background variants
- Quote cards
- Animated OG video generation
- AI-assisted layouts

## Tradeoffs

### Why Static Generation Wins

- Simpler infrastructure
- Better cacheability
- No runtime billing
- No cold starts
- Better reliability
- Easier debugging
- Cleaner deployment topology

### Accepted Limitations

- Images update only on deploy
- Storage increases with page count
- No runtime personalization

## Implementation Order

### Phase 1

- Add metadata tags
- Create generator script
- Generate homepage OG image
- Validate previews

### Phase 2

- Generate blog post images
- Add collection support
- Improve typography/layout

### Phase 3

- Add caching headers
- Add optimization passes
- Add template abstraction

### Phase 4

- Add incremental generation
- Add visual regression testing
- Add theme variants

## Success Criteria

System is successful when:

- Every page has a valid OG image
- Images render correctly across:
  - X/Twitter
  - Discord
  - Slack
  - LinkedIn
  - Facebook
- Build remains stable
- No runtime services required
- OG generation adds minimal operational burden
- Visual quality is consistent across collections

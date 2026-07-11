---
title: Storybook for Ruby View Components in Bridgetown
description: "How I wired Storybook up to andrewm.codes, a Bridgetown 2.2 site with Ruby ViewComponent-style components — by having Bridgetown render each component to a flat HTML fixture and letting Storybook import the real markup, instead of reimplementing components in JS."
tags:
  - bridgetown
  - ruby
  - storybook
  - viewcomponent
  - webdev
date: 2026-07-10 20:00:00 -0700
categories:
  - tutorials
---

andrewm.codes is a [Bridgetown](https://www.bridgetownrb.com) 2.2 site with ERB layouts and a small library of ViewComponent-style Ruby components — `Button`, `Text`, `Heading`, `Note`, and so on, each with a `.rb` for logic and an `.erb` for markup. I wanted a way to look at every variant of every component in isolation, the way you would with Storybook on a React or Vue codebase, without introducing a second implementation of each component in JavaScript.

Storybook doesn't know anything about Ruby. It renders whatever HTML (or framework component) a story hands it. So the trick isn't teaching Storybook to speak Ruby — it's having Bridgetown do what it already does best (render Ruby components to HTML) and letting Storybook display the output.

## The shape of it

There are five pieces, and each one earns its place:

1. A `stories` collection in `bridgetown.config.yml` that renders `src/_stories/*.erb` fixtures to `/stories/<name>/`.
2. One fixture file per component in `src/_stories/`, each just rendering that component's variants.
3. A production-only builder that deletes `output/stories` after the build so none of it ships.
4. A `.storybook/` config that boots Storybook against plain HTML instead of a JS framework.
5. One `.stories.js` file per component that imports the rendered fixture's HTML as a raw string.

### 1. The stories collection

```yaml
# bridgetown.config.yml
collections:
  stories:
    output: true
    permalink: "/stories/:slug/"
```

This is a real Bridgetown collection, so `src/_stories/button.erb` builds to `output/stories/button/index.html` on every `bin/bridgetown build`, in every environment — dev, test, and production all render it the same way.

### 2. A fixture per component

Each file in `src/_stories/` renders the actual component, not a mock of it:

```erb
<!-- src/_stories/button.erb -->
---
title: Button
---

<div class="space-y-6">
  <div class="space-y-2">
    <p class="font-mono text-xs text-sage-10">Variants</p>
    <div class="flex flex-wrap items-center gap-3">
      <%= render Button.new(variant: :primary) do %>Primary<% end %>
      <%= render Button.new(variant: :secondary) do %>Secondary<% end %>
      <%= render Button.new(variant: :ghost) do %>Ghost<% end %>
      <%= render Button.new(variant: :text) do %>Text<% end %>
    </div>
  </div>

  <div class="space-y-2">
    <p class="font-mono text-xs text-sage-10">Sizes</p>
    <div class="flex flex-wrap items-center gap-3">
      <%= render Button.new(size: :xs) do %>XS<% end %>
      <%= render Button.new(size: :sm) do %>SM<% end %>
      <%= render Button.new(size: :md) do %>MD<% end %>
    </div>
  </div>
</div>
```

Because there's a real `Button` Ruby class behind this, the fixture can never drift from what the site actually ships — it's not a JSX reimplementation that someone forgets to update when `button.rb` changes.

The fixtures deliberately skip layouts. `src/_stories/_defaults.yml` sets `sitemap: false` and nothing else — no `layout:` key — so each one renders as a bare HTML fragment, just the component markup with no `<html>`, `<head>`, or site chrome around it. That's exactly what Storybook wants to import.

### 3. Keeping fixtures out of production

The `stories` collection has no environment guard, so it renders in every build — dev, test, and production alike. That's on purpose: conditionally registering a whole collection is more moving parts than deleting a directory afterward. A builder handles the cleanup:

```ruby
# plugins/builders/stories.rb
class Builders::Stories < SiteBuilder
  def build
    return unless Bridgetown.env.production?

    hook :site, :post_write do |site|
      FileUtils.rm_rf(File.join(site.config.destination, "stories"))
    end
  end
end
```

In dev and test, `output/stories/` sticks around so Storybook has something to read. In production, this hook wipes it right after the build finishes, so none of these no-layout fragment pages ever reach Cloudflare.

### 4. Pointing Storybook at plain HTML

Since there's no JS framework involved, Storybook's [`@storybook/html-vite`](https://storybook.js.org/docs/get-started/html) framework is the right fit — it exists for exactly this: static or server-rendered HTML with no component framework backing it.

```js
// .storybook/main.js
const config = {
  framework: "@storybook/html-vite",
  stories: ["../stories/**/*.stories.js"],
};

export default config;
```

```js
// .storybook/preview.js
import "../frontend/styles/index.css";

const preview = {
  parameters: { layout: "fullscreen" },
  decorators: [
    (story) =>
      `<div data-theme="dark" class="bg-sage-1 text-sage-12 font-sans p-8 min-h-screen">${story()}</div>`,
  ],
};

export default preview;
```

Importing the site's real `frontend/styles/index.css` means Storybook gets the exact same Tailwind v4 + Radix Sage/Mint tokens as the live site. The decorator matters more than it looks: the design tokens are scoped to a `[data-theme]` attribute, so without wrapping every story in a `data-theme="dark"` container, the CSS custom properties never resolve and everything renders unstyled.

### 5. Importing rendered HTML as a story

Each component gets a matching CSF file that just imports the fixture's rendered output as a raw string:

```js
// stories/Button.stories.js
import html from "../output/stories/button/index.html?raw";

export default {
  title: "Components/Button",
};

export const Overview = {
  render: () => html,
};
```

Vite's `?raw` suffix imports the file's contents as a plain string instead of trying to parse it as a module, and `@storybook/html-vite`'s `render` function accepts that string directly. There's no re-rendering happening on Storybook's side — it's a raw HTML file being dropped into the DOM.

## Wiring it into the dev workflow

Since Storybook is reading `output/stories/*` off disk, Bridgetown has to build before Storybook starts, and that build has to run again any time a component or fixture changes — this isn't a live-reloading Ruby dev server, it's a static handoff. Two `mise` tasks make that a single command:

```toml
[tasks.storybook]
description = "Build story pages + start Storybook dev server"
run = "bin/bridgetown build && pnpm exec storybook dev -p 6006 --no-open"

[tasks."storybook:build"]
description = "Build story pages + a static Storybook bundle"
run = "bin/bridgetown build && pnpm exec storybook build"
```

`mise run storybook` builds the site once, then starts Storybook's dev server on top of the fixtures that build produced. If I change a component's Ruby or a fixture's ERB, I re-run the task — there's no file-watcher stitching the two together yet.

## Trade-offs

This gets the one thing I actually wanted: Storybook shows the literal HTML the site ships, generated by the same Ruby components in production, so there's no second implementation to keep in sync. That's worth the trade-offs it comes with:

- **No interactive controls.** Since each story is a static string baked in at build time, Storybook's `argTypes`/`args` controls wouldn't do anything — there's no live component to re-render when a control changes. If I want to see every variant of a component, I write them all into the fixture file, the way `button.erb` renders all four variants and five sizes in one story.
- **No hot reload.** Editing `button.rb` or `button.erb` doesn't update Storybook until I rerun `bin/bridgetown build`. For a small component library this hasn't been painful enough to solve yet.
- **One more directory to keep out of production.** Bare-fragment pages with no layout and no real content are exactly the kind of thing that's easy to accidentally ship — `sitemap: false` plus the post-build `rm -rf` in `Builders::Stories` covers it, but it's a second thing to remember if the pattern gets copied elsewhere.

## Adding a new component's story

The full loop for a new component is four steps:

1. Add `src/_stories/<name>.erb` with a `title:` front matter key and the component rendered with whatever variants matter.
2. Add `stories/<Name>.stories.js` importing `../output/stories/<name>/index.html?raw` and exporting an `Overview` story.
3. Run `mise run storybook`.
4. Open `http://localhost:6006` and check it against the live component in `mise run dev`.

Seven components are wired up this way today — `Button`, `Heading`, `Icon`, `Link`, `Note`, `TagCloud`, and `Text` — and the pattern holds up cleanly as the component library grows.

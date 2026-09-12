# Post types: structure and front matter

Four types, one voice (see SKILL.md). Each has a characteristic shape and front matter. Use today's date. Keep front matter lean — the templates below are complete; don't add extra keys.

## Date format

Blog posts (recent): `date: YYYY-MM-DD 00:00:00.000000000 Z`
Snippets: `date: YYYY-MM-DD HH:MM:SS.000000000 -07:00` (Pacific offset is fine)

Use the current date. Don't backdate.

## `description` field

One or two plain sentences, SEO-useful but human. It's what shows in search results and social cards, so make it say what the post actually delivers, in his voice. Examples he's used:

- "Pieces put memories behind a paid plan, so I pulled 358 saved snippets out of its local API and turned them into plain Markdown I own."
- "A short, fun look at Ruby's shovel operator (<<): what it does on arrays and strings, and why you can chain it even though you probably shouldn't."
- "Improve Rails page speed by self-hosting web fonts instead of relying on third-party font CDNs."

Wrap in quotes if it contains a colon or special characters.

## `tags`

Lowercase, kebab-case, 2–4 tags. Draw from his existing vocabulary when they fit: `ruby`, `rails`, `beginners`, `macos`, `bridgetown`, `obsidian`, `tooling`, `github`, `actions`, `ci`, `unix`, `markdown`, `tailwindcss`, `svg`, `productivity`, `personal`, `adhd`. Add a new tag only when nothing existing fits.

## `categories`

- `tutorials` — anything technical: how-tos, TILs, and technical story posts (this is the default for most posts).
- `blog` — personal, reflective, or opinion pieces with little/no code.

Snippets do **not** need a `categories` key — it's set automatically for that collection.

---

## 1. Tutorial

A step-by-step how-to. The longest, most structured type. Reader should be able to follow along and end up with a working result.

**Shape:**
- Hook: who this is for + what they'll have at the end, concretely. ("Whether you are a gem maintaining machine or new to the world of authoring gems, this tutorial is for you.")
- Optional early "> Skip to the bottom if you'd just like to see the result!" blockquote.
- Background/concepts section if needed (link out to canonical docs rather than re-explaining).
- Numbered or `##`-headed steps, each with the exact command/code and a screenshot placeholder where a visual helps.
- Real output shown and explained ("This output says:" → bullet list decoding it).
- A "final version" section pasting the complete config/file.
- `## Final Thoughts` or `## Summary`: caveats, next enhancements to explore, and a warm sign-off.

**Front matter:**
```yaml
---
title: Automating Ruby Gem Releases with GitHub Actions
description: "One-to-two sentence summary of what the reader will build and why."
tags:
  - ruby
  - actions
  - ci
date: 2026-09-11 00:00:00.000000000 Z
categories:
  - tutorials
---
```

Add `featured: true` only if Andrew says it's a flagship post. Add `seo_title:` only if the title is long/awkward for search and he wants a shorter one.

**Images:** He references images with the ImageKit helper:
`![Alt text](<%= imagekit_url 'posts/<slug>/<image-name>.png', :medium %>)`
The `:medium` preset is optional. Only include image lines if there are actual images; otherwise leave a clear `<!-- screenshot: description -->` note or omit and mention it to Andrew.

The actual upload workflow: he stages a post's images in `tmp/post-images/<slug>/`, then runs `mise run upload-images <slug>` to push them to ImageKit under `posts/<slug>/` and print paste-ready `imagekit_url` refs (`-- --dry-run` previews). So if the post needs images, name them sensibly under that slug path and point Andrew at that command rather than inventing image files that don't exist yet.

---

## 2. Reflection / story post

Narrative: something happened, he dug into it, here's what he did and the broader lesson. The Pieces→Obsidian post is the model. Technical, but organized as a story rather than reproducible steps.

**Shape:**
- Hook: the triggering event, often with the actual message/quote/screenshot. ("I opened Pieces today and was greeted with this message:")
- The stakes / "one problem" beat — why this mattered to him.
- Exploration sections (`## Finding the Data`, `## Understanding the Export`, `## What I Kept`, `## What I Didn't Keep`) — each a chunk of the investigation, honest about surprises and dead ends.
- Bulleted findings where he enumerates what he discovered (great place for concrete numbers).
- The result, often anticlimactic on purpose ("Pretty boring. / That's exactly what I wanted.").
- `## Final Thoughts`: the zoom-out lesson, bolded, plus his honest posture toward the tool/situation.

**Front matter:** same as tutorial. Use `categories: tutorials` if it's technical, `blog` if it's mostly personal reflection.

---

## 3. TIL / short take

A small, fun discovery. Short, playful, one idea. The shovel-operator post is the model.

**Shape:**
- Optional heads-up blockquote setting the tone ("> Heads up! This is not *actually* a deep dive 😬").
- A short, energetic hook — often genuine enthusiasm ("I almost forgot how fun it can be to code in Ruby!").
- The setup: where he ran into it (a code review, a doc, an experiment).
- The thing itself, with a tight code example.
- A `## TIL!` or similar beat with the discovery, allowed to be goofy ("Today I `/re(learned|membered)/` you can chain shovels!").
- A grounded close: the practical takeaway (often "you *can* but you probably *shouldn't*") and a sign-off ("Happy coding!").

**Front matter:**
```yaml
---
title: "Ruby's Shovel Method: Digging Deeper"
description: "Short, human one-liner about the fun little thing."
tags:
  - ruby
  - devjournal
date: 2026-09-11 00:00:00.000000000 Z
categories:
  - tutorials
---
```

Quote the title if it contains a colon.

---

## 4. Snippet

A reusable command or function he wants to find later. Terse, reference-style, minimal prose. Lives in `src/_posts/snippets/`. The kill-process-on-port snippet is the model.

**Shape (use these exact section headings):**
- One-sentence intro, usually the same as the description — the real reason he saved it ("I often have to kill processes that weren't stopped correctly on different ports and can never remember the command.").
- `## Snippet` — the code block.
- `## Usage` — numbered steps to use it.
- `## Extending` (optional) — a fuller version, e.g. wrapping it in a function, then how to call it.

**Front matter (no `categories` key):**
```yaml
---
title: Kill Process Running on a Specific Port
description: "Why I saved this — the recurring annoyance it solves."
tags:
  - unix
date: 2026-09-11 20:23:33.000000000 -07:00
---
```

Snippets stay short and dry — this is the one type where personality/humor is minimal. It's a note to his future self.

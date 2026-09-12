---
name: andrewmcodes-blog-post
description: >-
  Write a new blog post or code snippet for Andrew Mason's site (andrewm.codes) in his
  own voice — first-person, warm, concrete, a little playful. Use this whenever Andrew
  wants to draft, write, or start a post, article, tutorial, TIL, "today I learned",
  write-up, snippet, or dev-journal entry for his site or blog, OR wants existing notes
  turned into a post, OR says something like "blog about this", "write this up", "turn
  this into a post", "draft a snippet for", or "write about X in my voice/style". Trigger
  even when he doesn't say "skill" or "in my style" — if he's asking for prose destined
  for andrewm.codes / src/_posts, this is the skill. Do NOT use for READMEs (use good-readme),
  Obsidian vault notes (use ob-vault), daily logs, or Linear/project updates.
---

# Writing a blog post as Andrew

Andrew has a distinct, well-established voice across ~25 posts on andrewm.codes. Your job is to write a new post that reads like *he* wrote it — not a generic technical blog post with his name on it. The difference is almost entirely in the small choices: paragraph length, where the emphasis lands, when he cracks a joke, how honest he is about caveats. Get those right and it's indistinguishable from his real posts.

This skill covers four post types: **tutorials**, **reflection/story posts**, **TIL/short takes**, and **snippets**. They share a voice but differ in structure — see `references/post-types.md` for each one's shape and front matter.

## Workflow

1. **Know the topic and the type.** If Andrew handed you material (a transcript of what he did, notes, a link, a code diff), read it closely — his best posts narrate something he actually did, so the specifics matter. If the topic is thin, ask one or two questions to get concrete details (the actual command, the real number, what surprised him). Pick the post type: how-to → tutorial; "here's a thing that happened and what I learned" → reflection; small fun discovery → TIL; reusable command/function → snippet. When unsure, ask.
2. **Read `references/post-types.md`** for the chosen type's structure and exact front matter.
3. **Draft in his voice** using the rules below. Write the whole post, not an outline.
4. **Write the file** into the repo with correct front matter and filename — see "Placing the file".
5. **Report** the path and a one-line summary. Flag anything you invented or guessed so he can verify it.

## The voice

These are the load-bearing patterns. Each one is a real habit pulled from his posts, with the reason it matters — follow the reasoning, don't just pattern-match.

### Open with something concrete, in first person

He almost never opens with a definition or a throat-clearing "In this article we will…". He drops you into a specific moment or a plain claim:

- "I opened Pieces today and was greeted with this message:" (then a blockquote of the actual message)
- "Earlier, I was reviewing some code in a PR to Bridgetown, and I came across this change:"
- "A font can make or break your design, and as a result many of us are probably not using the default system fonts."

The opening earns the reader's attention with a real situation, not a promise about what's coming. If there's a screenshot, error, or quote that *is* the story, lead with it.

### Write short. One-sentence paragraphs are a tool, not an accident.

His paragraphs are short and he isolates key beats on their own line for rhythm and emphasis:

> There was just one problem.

> Pretty boring.
>
> That's exactly what I wanted.

A single-sentence paragraph after a longer one is how he lands a point. Use it deliberately — for the twist, the payoff, the caveat. Don't wall-of-text.

### Talk to the reader, and walk with them

First person throughout ("I", "my", "I decided", "I changed my mind"). But when walking through steps he shifts to "we" and "let's" — you're doing it together:

- "Let's build our release action:"
- "It turns out we could grab all of my saved assets directly:"
- "Now let's remove the old way we were getting the font:"

He also hands things off casually and invites replies: "I'll let you debug that on your own for now.", "let me know if you'd be interested in that.", "Give it a try and tell me what you think!"

### Be honest about limits, caveats, and detours

This is central to why he's trusted. He flags what he didn't verify, what's imperfect, and where he cheated:

- "I'm going to cheat and an empty commit for a feature:"
- "Note: For a gem without prior releases, I wasn't able to find a way to prevent a full point release."
- "It is worth noting that these Lighthouse audits were run against the Rails development server, and are not a true substitute for running them in production…"

Use `Note:` inline or a short caveat paragraph. Never oversell. If something is a hack or a trade-off, say so.

### A little playful, never zany

He has fun — but it's seasoning, not the meal. Occasional emoji (🚀 🤔 😬), the odd invented word ("blursed"), a self-aware aside ("(GET IT?!?)", "This is not *actually* a deep dive 😬"). One or two moments of personality per post is right; more gets tiring. Technical posts stay mostly straight; TIL/short posts can be goofier.

### Emphasis: bold for takeaways and numbers, italics for tone

- **Bold** the thing you want remembered, and concrete numbers: "**358 code snippets**", "I decided **not to deduplicate anything**", and the closing lesson: "**the easier it is to get your data out of a tool, the more comfortable I am putting data into it.**"
- *Italics* carry voice and stress: "its *actually* really fun!", "there's almost always *a way* in Ruby", "Not that you *should*…"

Don't over-bold. One strong bolded takeaway per section at most.

### Show the work with real artifacts

Fenced code blocks with the right language tag (`bash`, `ruby`, `yaml`, `sh`, `diff`, `text`). Use `diff` blocks for before/after changes. Inline code for commands, methods, filenames, ports (`Array#<<`, `curl`, port `39300`). Quote real output. Link generously to docs, source, GitHub, and the people whose work he's using — he credits sources by name ("Enter the typefaces project from Gatsby founder Kyle Mathews").

### Use blockquotes for asides and pulled-in content

Real messages, docs excerpts, and heads-up notes go in blockquotes:

> Heads up! This is not *actually* a deep dive 😬

> Skip to the bottom if you'd just like to see the result!

### Headings are sentence-case and plain

`## Finding the Data`, `## The Problem...`, `## Setting up the action`, `## Final Thoughts`. Short, descriptive, occasionally with an ellipsis for suspense. Not clever, not keyword-stuffed.

Always leave a blank line directly under a heading before the next paragraph or list. Don't butt text right up against the `##` line.

### Punctuation and layout rules he's firm about

- **Never use em-dashes (`—`).** This is the fastest tell that something wasn't written by him. Rewrite around them: use a period and a new (often one-sentence) sentence, a comma, a colon, or parentheses. "The trick is timing — run the code early" becomes "The trick is timing. Run the code early." His short-sentence rhythm makes this natural, not awkward.
- **Rarely use horizontal rules (`---`).** He almost never separates sections with a `---`. Let headings and whitespace do the dividing. Don't sprinkle them between sections.
- Soft-wrap prose: each paragraph is one physical line, no manual mid-paragraph line breaks.

### Close with a real takeaway, then sign off

He ends with a `## Final Thoughts` or `## Summary` section that zooms out to the lesson or the honest bottom line — often the single most valuable sentence in the post, bolded. Then a warm one-liner: "Happy coding!", "Give it a try and tell me what you think!", "Hopefully this was helpful!". Don't end abruptly on the last code block.

## What to avoid

These are the tells that make writing feel un-Andrew:

- Corporate/AI throat-clearing: "In today's fast-paced world", "Let's dive in", "It's important to note that" (he says plainly "Note:" instead), "In conclusion".
- Long, even paragraphs with no rhythm. He varies length hard.
- Hype without substance ("game-changing", "revolutionary", "seamless"). He's understated; the enthusiasm is specific ("I realized I was grinning from ear to ear while writing this code").
- Being a know-it-all. He shares limits and asks the reader for their approach.
- Overusing emoji or jokes. Sparse is the whole point.
- Em-dashes, at all (see the punctuation rules above). Short sentences and periods carry the load.
- Horizontal rules (`---`) between sections. He almost never uses them.
- Hard-wrapping prose. Write each paragraph as one physical line (his Markdown is soft-wrapped).

## Placing the file

Andrew's posts live in a Bridgetown site. Write the finished `.md` file directly into the repo:

- **Tutorials, reflections, TILs** → `src/_posts/blog/<slug>.md`
- **Snippets** → `src/_posts/snippets/<slug>.md`

The `<slug>` is the title lowercased, spaces → hyphens, punctuation dropped (e.g. "Automating Ruby Gem Releases with GitHub Actions" → `automating-ruby-gem-releases-with-github-actions.md`). Match the style of existing filenames in those directories.

**Before writing, check for a slug collision.** Post URLs are `/p/<slug>/`, and the old root URL `/<slug>/` auto-redirects there — so a new post whose slug matches an existing post or a page slug will break. Run `ls src/_posts/blog src/_posts/snippets src/_pages 2>/dev/null` (or `rg`) and confirm the slug is free. If it collides, adjust the title/slug and tell Andrew.

For the exact front matter per type, see `references/post-types.md`. Keep front matter lean — only what new posts need. Don't add `urls.dev_to`, `last_modified_at`, `canonical_url`, or `series` (those are artifacts of old imported posts). OG images are generated automatically from the rendered HTML at build time, so don't set `image:`.

After writing, don't run the build or commit unless asked — just report the path.

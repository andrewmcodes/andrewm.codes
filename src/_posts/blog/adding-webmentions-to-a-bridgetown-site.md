---
title: Adding Webmentions to a Bridgetown Site
description: "How I added webmentions to my static Bridgetown site using webmention.io, Bridgy, and a nightly GitHub Actions job, so replies and likes from Bluesky show up right under my posts."
tags:
  - bridgetown
  - indieweb
  - actions
  - ruby
date: 2026-09-11 00:00:00.000000000 Z
categories:
  - tutorials
---

Someone replied to one of my posts recently, and it showed up right underneath it:

![A webmention reply rendered under one of my posts](<%= imagekit_url 'posts/adding-webmentions-to-a-bridgetown-site/webmention-example.png', :medium %>)

> good to see you blerging again

No comment system. No third-party embed. No JavaScript widget phoning home from the corner of the page. Andrea wrote that reply somewhere else entirely, and it landed on my site as plain text that now lives in my Git repo.

That's a webmention, and I finally set them up on this site.

Here's how it all fits together.

## What even is a webmention?

A [webmention](https://www.w3.org/TR/webmention/) is a small notification. When someone links to one of your pages from their own site, their site sends a tiny POST to yours that says, in effect, "hey, I mentioned you over here." Your site gets to decide what to do with that: ignore it, count it, or render it as a reply.

It's a [W3C Recommendation](https://www.w3.org/TR/webmention/) and a core piece of the [IndieWeb](https://indieweb.org/Webmention). Think of it as the open, decentralized version of "3 people liked this," except the likes and replies come from all over the web instead of from inside one company's walls.

Great in theory. There were two problems for a site like mine.

First, my site is completely static. It's a Bridgetown build deployed to Cloudflare as plain files, so there's no server sitting there ready to receive a POST.

Second, almost nobody writes replies on their own blog anymore. They reply on Bluesky. They like the post on Mastodon. The conversation happens on social, not on personal sites.

Both problems have the same fix: let someone else do the receiving.

## The moving parts

Before the step-by-step, here's the shape of the whole thing, because it only clicked for me once I could see all the pieces at once:

- **[webmention.io](https://webmention.io)** receives mentions on my behalf, since my static site can't.
- **[Bridgy](https://brid.gy)** watches my social accounts and turns likes, reposts, and replies into webmentions.
- **A GitHub Actions job** pulls the collected mentions into a JSON file in my repo once a day.
- **A Bridgetown component** reads that JSON and renders it under each post at build time.

Nothing runs on a server of mine, because I don't have one. Every part is either a hosted service or a build-time step. That constraint shaped every decision below.

## Step 1: Tell the world where to send mentions

First, point people at an endpoint that can actually receive a webmention. [webmention.io](https://webmention.io), built by [Aaron Parecki](https://aaronparecki.com), is a hosted endpoint that does exactly this.

Add the discovery link tags to the `<head>` of your layout. Mine live in `src/_layouts/default.erb`:

```erb
<link
  rel="webmention"
  href="https://webmention.io/andrewm.codes/webmention"
>

<link rel="pingback" href="https://webmention.io/andrewm.codes/xmlrpc">
```

Any sender that finds these tags now knows where to deliver mentions for my domain.

You sign in to webmention.io with your own domain using [IndieAuth](https://indieweb.org/IndieAuth), which authenticates you through the `rel="me"` links on your site. So while we're in the `<head>`, add those too, pointing at your profiles:

```erb
<link rel="me" href="https://bsky.app/profile/andrewm.codes">
<link rel="me" href="https://github.com/andrewmcodes">
<link rel="me" href="https://www.linkedin.com/in/andrew-mason">
<link rel="me" href="https://x.com/andrewmcodes">
```

## Step 2: Backfeed from social with Bridgy

An endpoint that receives webmentions is only useful if anyone is sending them. That's where [Bridgy](https://brid.gy), from [Ryan Barrett](https://snarfed.org), comes in.

Bridgy watches your connected social accounts, notices when someone replies to, likes, or reposts a link to one of your posts, and sends a webmention to your endpoint for each interaction. This is called backfeed, and it's the bridge between "the conversation happens on Bluesky" and "the conversation shows up on my site."

Connect your accounts in Bridgy, and it takes care of the polling. That Bluesky reply from the screenshot at the top? Bridgy saw it and forwarded it to webmention.io, which is how it reached me at all.

## Step 3: Pull the mentions into the repo

At this point webmention.io is collecting mentions, but my static build has no idea they exist. I need to pull them in.

webmention.io exposes a per-domain [JF2](https://www.w3.org/TR/jf2/) feed. This little script pages through it and writes the result to `src/_data/webmentions.json`, which Bridgetown then exposes as `site.data.webmentions`:

```js
// scripts/fetch-webmentions.mjs

const DOMAIN = "andrewm.codes";
const PER_PAGE = 200;

const token = process.env.WEBMENTION_IO_TOKEN;
if (!token) {
  console.warn("WEBMENTION_IO_TOKEN not set — skipping fetch, leaving src/_data/webmentions.json unchanged.");
  process.exit(0);
}

async function fetchAll() {
  const children = [];
  for (let page = 0; ; page++) {
    const url = new URL("https://webmention.io/api/mentions.jf2");
    url.searchParams.set("domain", DOMAIN);
    url.searchParams.set("token", token);
    url.searchParams.set("per-page", String(PER_PAGE));
    url.searchParams.set("page", String(page));

    const res = await fetch(url);
    if (!res.ok) {
      throw new Error(`webmention.io responded ${res.status} ${res.statusText}`);
    }
    const feed = await res.json();
    const batch = feed.children ?? [];
    children.push(...batch);
    if (batch.length < PER_PAGE) break;
  }
  return children;
}
```

The per-domain feed needs the account API token, which I keep out of the repo. Locally it comes from my Keychain via `fnox`, and in CI it's a repo secret.

Note: if the token is missing, the script logs a warning and exits `0` without touching the committed file. That was deliberate. I never want a missing secret to break a build. A build with slightly stale webmentions is fine. A build that fails is not.

I run it locally with a `mise` task:

```sh
mise run webmentions
```

## Step 4: Refresh nightly with GitHub Actions

I don't want to remember to run that script, so a scheduled GitHub Action does it for me every morning:

```yaml
# .github/workflows/webmentions.yml

name: Sync webmentions
on:
  schedule: [{ cron: "0 5 * * *" }]
  workflow_dispatch:

permissions:
  contents: write
jobs:
  sync:
    runs-on: ubuntu-latest
    outputs:
      changed: ${{ steps.commit.outputs.changed }}
    steps:
      - uses: actions/checkout@v7
      - uses: actions/setup-node@v7
        with: { node-version: "22" }
      - name: Fetch webmentions from webmention.io
        env:
          WEBMENTION_IO_TOKEN: ${{ secrets.WEBMENTION_IO_TOKEN }}
        run: node scripts/fetch-webmentions.mjs

      - uses: ./.github/actions/commit-data
        id: commit
        with:
          paths: src/_data/webmentions.json
          message: "chore(data): refresh webmentions"
```

It fetches, then commits `webmentions.json` only if it actually changed. I also gated the deploy that follows on that same `changed` output, so the site only rebuilds when there's something new to show.

Note: the `workflow_dispatch` trigger is there so I can click "Run workflow" and pull mentions on demand without waiting for the 5am cron. Handy right after someone tells you they replied to something.

## Step 5: Render them under the post

Now for the part that actually shows up on the page. I built a `Webmentions` ViewComponent that reads the data file and filters it down to the mentions for the current post.

The matching is simple. Every entry in the feed has a `wm-target`, and I keep the ones whose target is this post's absolute URL:

```ruby
def target
  "#{@site.metadata.url}#{url}"
end

def mentions
  @mentions ||= begin
    children = @site.data.webmentions&.children
    Array(children).select { |wm| wm["wm-target"] == target }
  end
end
```

From there it's mostly counting. Likes, reposts, and bookmarks become a little tally in the header, and replies become the thread you see below it.

One decision I want to call out, because it matters more than it looks. When I render a reply, I use the plain-text content, never the HTML:

```ruby
def content_text(wm)
  text = wm.dig("content", "text")
  return nil if text.nil? || text.strip.empty?
  (text.length > 280) ? "#{text[0, 279].rstrip}…" : text
end
```

This content comes from strangers on the internet. Dropping their raw HTML straight into my page would be an open invitation for injected markup. Plain text, truncated, is the safe call, and it's plenty for a reply.

Wiring it into the post layout is one line, passing the post's URL and its `syndication` front matter:

```erb
<%= render Webmentions.new(url: resource.relative_url, syndication: resource.data.syndication) %>
```

That `syndication:` bit is a small IndieWeb nicety. It's an array of the places I cross-posted the article to, and the component renders a "syndicated to" row of links (with the RSS feed always tacked on at the end):

```yaml
syndication:
  - https://bsky.app/profile/andrewm.codes/post/abc123
```

## The result

Put it all together and you get the block from the top of this post: a "webmentions" heading, a tally when there are likes or reposts, the replies themselves, and a small form for anyone who wants to send a webmention by hand.

The replies read like comments. They just don't live in a comment system. They live in a JSON file in my repo, gathered from wherever the conversation actually happened.

## Final Thoughts

I like this setup more than any comment system I've run before, and the reason is ownership.

**Every reply on my site is plain JSON in my Git repo now, not a row in someone else's database.** If webmention.io or Bridgy disappeared tomorrow, I'd still have every mention I've already collected, sitting right next to my posts. That's the whole IndieWeb pitch in one sentence, and it's the same reason I keep reaching for static sites in the first place.

It's also not much code. A fetch script, a scheduled Action, and one component. Most of the heavy lifting is done by two hosted services maintained by people who have been doing this far longer than I have, so real credit to Aaron Parecki and Ryan Barrett for webmention.io and Bridgy.

If you run a static site and you've been missing having a conversation on it, give webmentions a try. I'd love it if the first one you get is a reply to this post.

Happy coding!

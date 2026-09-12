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

[Andrea Fomera](https://afomera.dev) replied to [one of my posts](https://bsky.app/profile/afomera.dev/post/3mvbzefpqzs2t) recently, and it showed up right underneath it:

![A webmention reply rendered under one of my posts](<%= imagekit_url 'posts/adding-webmentions-to-a-bridgetown-site/webmention-example.png', :medium %>)

> good to see you blerging again

No comment system. No third-party embed. No JavaScript widget loading in the corner of the page. Andrea wrote that reply somewhere else entirely, and it landed on my site as plain text that now lives in [my Git repo](https://github.com/andrewmcodes/andrewm.codes).

That's a webmention, and I finally set them up on this site.

Here's how it all fits together.

## What even is a webmention?

A [webmention](https://www.w3.org/TR/webmention/) is a small notification. When someone links to one of your pages from their own site, their site sends a tiny POST to yours with two URLs: the page doing the mentioning (`source`) and the page being mentioned (`target`). In effect: "hey, I mentioned you over here." Your site gets to decide what to do with that: ignore it, count it, or render it as a reply.

It's a [W3C Recommendation](https://www.w3.org/TR/webmention/) and a core piece of the [IndieWeb](https://indieweb.org/Webmention). Think of it as the open, decentralized version of "3 people liked this," except the likes and replies come from all over the web instead of from within the walled garden of a single social media site.

Great in theory. There are two problems for a site like mine.

First, my site is completely static. It's a [Bridgetown](https://www.bridgetownrb.com) build deployed to Cloudflare as static files, so there's no server sitting there ready to receive a POST.

Second, almost nobody writes replies on their own blog anymore. They reply on Bluesky. They like the post on Mastodon. The conversation happens on social, not on personal sites.

Both come down to the same fix: put hosted services at the boundary and keep my own site completely static.

## The moving parts

Before the step-by-step, here's the shape of the whole thing, because it only clicked for me once I could see all the pieces at once:

- **[webmention.io](https://webmention.io)** receives mentions on my behalf, since my static site can't.
- **[Bridgy](https://brid.gy)** watches my social accounts and turns likes, reposts, and replies into webmentions.
- **A GitHub Actions job** pulls the collected mentions into a JSON file in my repo once a day.
- **A Bridgetown component** reads that JSON and renders it under each post at build time.

Nothing runs on a server of mine, because I don't have one. Every part is either a hosted service or a build-time step. That constraint shaped every decision below.

## Step 1: Tell the world where to send mentions

First, point people at an endpoint that can actually receive a webmention. [webmention.io](https://webmention.io), built by [Aaron Parecki](https://aaronparecki.com), is a hosted endpoint that does exactly this.

Add the discovery link tags to the `<head>` of your layout. Mine live in [`src/_layouts/default.erb`](https://github.com/andrewmcodes/andrewm.codes/blob/main/src/_layouts/default.erb):

```erb
<link
  rel="webmention"
  href="https://webmention.io/andrewm.codes/webmention"
>

<link rel="pingback" href="https://webmention.io/andrewm.codes/xmlrpc">
```

Any sender that finds these tags now knows where to deliver mentions for my domain.

You sign in to webmention.io with your own domain using [IndieAuth](https://indieweb.org/IndieAuth). For that to work, your site needs to expose `rel="me"` links pointing at the profiles that make up your identity. So while we're in the `<head>`, add those too:

```erb
<link rel="me" href="https://bsky.app/profile/andrewm.codes">
<link rel="me" href="https://github.com/andrewmcodes">
<link rel="me" href="https://www.linkedin.com/in/andrew-mason">
<link rel="me" href="https://x.com/andrewmcodes">
```

## Step 2: Backfeed from social with Bridgy

An endpoint that receives webmentions is only useful if anyone is sending them. That's where [Ryan Barrett's](https://snarfed.org) [Bridgy](https://brid.gy) comes in.

Bridgy watches the social posts tied to your site and turns replies, likes, and reposts on them into webmentions sent back to your endpoint. This is called backfeed, and it's the bridge between "the conversation happens on Bluesky" and "the conversation shows up on my site."

Connect your accounts in Bridgy, and it takes care of the polling. That Bluesky reply from the screenshot at the top? Bridgy saw it and forwarded it to webmention.io, which is how it reached me at all.

Note: which networks Bridgy supports changes over time. It works well with Bluesky and the fediverse, and it used to cover Twitter, but that stopped once Twitter became X and locked down its API. Check [Bridgy](https://brid.gy) for what's currently supported before you count on a given account.

## Step 3: Pull the mentions into the repo

At this point webmention.io is collecting mentions, but my static build has no idea they exist. I need to pull them in.

webmention.io exposes a per-domain [JF2](https://www.w3.org/TR/jf2/) feed. This script pages through the feed, collects every entry, and writes them back out as a JF2 feed of its own in `src/_data/webmentions.json`, which Bridgetown then exposes as `site.data.webmentions`:

```ruby
# scripts/fetch-webmentions.rb

require "json"
require "net/http"
require "uri"

DOMAIN = "andrewm.codes"
PER_PAGE = 200
OUT = File.expand_path("../src/_data/webmentions.json", __dir__)

token = ENV["WEBMENTION_IO_TOKEN"]
if token.nil? || token.empty?
  warn "WEBMENTION_IO_TOKEN not set; skipping fetch, leaving src/_data/webmentions.json unchanged."
  exit 0
end

# Page through the JF2 feed until a short page signals the end.
def fetch_all(token)
  children = []
  page = 0

  loop do
    uri = URI("https://webmention.io/api/mentions.jf2")
    uri.query = URI.encode_www_form(
      "domain" => DOMAIN,
      "token" => token,
      "per-page" => PER_PAGE,
      "page" => page
    )

    response = Net::HTTP.get_response(uri)
    unless response.is_a?(Net::HTTPSuccess)
      raise "webmention.io responded #{response.code} #{response.message}"
    end

    batch = JSON.parse(response.body)["children"] || []
    children.concat(batch)
    break if batch.length < PER_PAGE

    page += 1
  end

  children
end

children = fetch_all(token)
# Newest first so the component can take the most recent without re-sorting.
children.sort_by! { |wm| wm["wm-received"].to_s }
children.reverse!

feed = {"type" => "feed", "name" => "Webmentions", "children" => children}
File.write(OUT, JSON.pretty_generate(feed) + "\n")
puts "Wrote #{children.length} webmentions to #{OUT}"
```

That `{ type, name, children }` shape is why the component reads `site.data.webmentions.children` later on. The full file, minus the header comment I trimmed here, is [`scripts/fetch-webmentions.rb`](https://github.com/andrewmcodes/andrewm.codes/blob/main/scripts/fetch-webmentions.rb). It leans entirely on Ruby's standard library, so there are no gems to install.

A single post's mentions can be fetched publicly, but pulling every mention for the whole domain needs the account API token, which I keep out of the repo. Locally it comes from my Keychain via [`fnox`](https://fnox.jdx.dev), and in CI it's a repo secret.

`fnox` is from [Jeff Dickey](https://jdx.dev), the same person behind [`mise`](https://mise.jdx.dev), which I use to manage tool versions and tasks all over this repo.

> BTW, we [interviewed Jeff on Remote Ruby](https://www.remoteruby.com/2260490/episodes/18785026-jeff-dickey-on-mise-precompiled-rubies-and-much-more) if you want to hear more about his projects like mise and fnox.

Note: if the token is missing, the script logs a warning and exits `0` without touching the committed file. That was deliberate. I never want a missing secret to break a build. A build with slightly stale webmentions is fine. A build that fails is not.

I run it locally with a `mise` task:

```sh
mise run webmentions
```

There's a deliberate choice hiding in this step. I could fetch webmention.io during every Bridgetown build instead, but I put Git in the middle on purpose. Once a mention is fetched, it's committed data in the repo, versioned right alongside the post it belongs to. Builds stay reproducible, I get a history of exactly what changed and when, and webmention.io doesn't have to be reachable for me to deploy. This is the step where the durable copy of a mention stops living on someone else's server and starts living in mine.

## Step 4: Refresh daily with GitHub Actions

I don't want to remember to run that script, so a scheduled GitHub Action does it for me once a day:

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
      - uses: ./.github/actions/setup
        with:
          node: false
      - name: Fetch webmentions from webmention.io
        env:
          WEBMENTION_IO_TOKEN: ${{ secrets.WEBMENTION_IO_TOKEN }}
        run: ruby scripts/fetch-webmentions.rb

      - uses: ./.github/actions/commit-data
        id: commit
        with:
          paths: src/_data/webmentions.json
          message: "chore(data): refresh webmentions"
```

It fetches, then commits `webmentions.json` only if it actually changed. The rest of [the workflow](https://github.com/andrewmcodes/andrewm.codes/blob/main/.github/workflows/webmentions.yml), which I've left out of the snippet, gates its deploy job on that same `changed` output, so the site only rebuilds when there's something new to show.

Note: the `workflow_dispatch` trigger is there so I can click "Run workflow" and pull mentions on demand without waiting for the next scheduled run. Handy right after someone tells you they replied to something.

## Step 5: Render them under the post

Now for the part that actually shows up on the page. I built a [`Webmentions` component](https://github.com/andrewmcodes/andrewm.codes/blob/main/src/_components/webmentions.rb), a [`Bridgetown::Component`](https://www.bridgetownrb.com/docs/components/ruby), that reads the data file and filters it down to the mentions for the current post.

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

From there, the component groups mentions by their `wm-property`. Likes, reposts, and bookmarks become a tally in the header, and reply-type entries become the thread you see below it.

One decision I want to call out, because it matters more than it looks. When I render a reply, I use the plain-text content, never the HTML:

```ruby
def content_text(wm)
  text = wm.dig("content", "text")
  return nil if text.nil? || text.strip.empty?
  (text.length > 280) ? "#{text[0, 279].rstrip}…" : text
end
```

This content comes from strangers on the internet. I could sanitize the HTML webmention.io hands me, but I don't want any of its formatting in the first place, so the simplest safe move is to not trust it at all. I render the plain-text version instead.

The 280-character cap in there is my own display choice, not something the protocol requires. I just want imported replies to stay lightweight underneath the post.

Wiring it into the [post layout](https://github.com/andrewmcodes/andrewm.codes/blob/main/src/_layouts/post.erb) is one line, passing the post's URL and its `syndication` front matter:

```erb
<%= render Webmentions.new(url: resource.relative_url, syndication: resource.data.syndication) %>
```

That `syndication:` bit is a small IndieWeb nicety. It's an array of the places I cross-posted the article to, and the component renders a "syndicated to" row of links (with the RSS feed always added at the end):

```yaml
syndication:
  - https://bsky.app/profile/andrewm.codes/post/abc123
```

## The result

Put it all together and you get the block from the top of this post: a "webmentions" heading, a tally when there are likes or reposts, the replies themselves, and a small form for anyone who wants to send a webmention by hand.

The replies read like comments. They just don't live in a comment system. They live in a JSON file in my repo, gathered from wherever the conversation actually happened.

## Final Thoughts

I like this setup more than any comment system I've run before, and the reason is ownership.

**Every reply on my site is plain JSON in my Git repo now, not a row in someone else's database.** If webmention.io or Bridgy disappeared tomorrow, the pipeline would stop collecting anything new, but nothing I've already gathered would vanish. My site would keep building with exactly the data it has today. That's the whole IndieWeb pitch in one sentence, and it's the same reason I keep reaching for static sites in the first place.

Owning the data has a quieter benefit too: moderation. I haven't had anyone reply with something heinous yet, and I'd rather not dare a reader to be the first, but if it happened I get the final say over what renders. I can filter or skip any mention I don't want on the page, and I can delete it outright from the [webmention.io dashboard](https://webmention.io/dashboard).

It's also not much code. A fetch script, a scheduled Action, and one component. Most of the heavy lifting is done by two hosted services maintained by people who have been doing this far longer than I have, so real credit to Aaron Parecki and Ryan Barrett for webmention.io and Bridgy.

If you run a static site and you've been missing having a conversation on it, give webmentions a try. I'd love it if the first one you get is a reply to this post.

Happy coding!

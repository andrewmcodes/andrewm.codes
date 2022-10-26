---
title: andrewm.codes
description: My personal website built with Bridgetown and deployed with Vercel.
tags:
  - bridgetown
  - vercel
  - tailwindcss
repo: andrewmcodes/andrewm.codes
website_url: https://andrewm.codes
last_modified_at: 2022-07-07T04:54:30.621Z
status: active
type: project
---

## Design

### Typography

I am using [IBM Plex Sans](https://www.ibm.com/plex/) on this site, a nice variable font, that I am self hosting. For markdown pages, I am using [the Tailwind CSS typography plugin](https://github.com/tailwindlabs/tailwindcss-typography) with a few modifications.

### CSS

I was an early adopter and am still a big fan of using [Tailwind CSS](https://tailwindcss.com/), which is what this site is built with. I couple it with [ViewComponent](https://viewcomponent.org) to make the markup clean and reusable.

## Development

[Bridgetown](https://bridgetownrb.com/) does most of the heavy lifting on this site - it’s a Ruby based static site generator that I have fallen in love with.

I am using [Tailwind CSS](https://tailwindcss.com/) and [ViewComponent](https://viewcomponent.org/) to build and design the UI. All posts are written in [Kramdown flavored markdown](https://kramdown.gettalong.org/) with ViewComponent’s sprinkled in. I store all of the images in [Cloudinary](https://cloudinary.com/invites/lpov9zyyucivvxsnalc5/ztosjslptijb8cyexrrt?t=default) and get my icons from [Nucleo](https://nucleoapp.com/?ref=11689).

Under the hood, [esbuild](https://esbuild.github.io/) is handling asset bundling. I use almost no JavaScript on this site, but I have sprinkled [Alpine.js](https://alpinejs.dev/) here and there for small interactions.

## Deployment

This site is [open source on GitHub](https://github.com/andrewmcodes/andrewm-codes-site) and that is how I deploy. The site is hosted on [Vercel](https://vercel.com/) and all pushes to the main branch trigger a deploy. I also use [Cloudflare](https://www.cloudflare.com/) for DNS and domain management.

## Tracking

I am using [Plausible Analytics](https://plausible.io/), which is a GDPR, CCPA and cookie law compliant site analytics tool. I chose a privacy focused tool because I just want to know what pages are popular, not get a breakdown of the users. This is a personal site afterall.

For the curious: you can find my public analytics dashboard on the [analytics page.](https://andrewm.codes/site/analytics/)

## Misc

I am trying to do more automated testing & monitoring this time around.

These are some of the things I am trying:

- [Checkly: Delightful Active Monitoring for Developers + Vercel Integration](https://www.checklyhq.com/)
  - Currently disabled while I am still working on the site.
- [GraphJSON - The easiest way to analyze event data + Vercel Integration](https://www.graphjson.com/)
  - Don't really know what to do with this yet.

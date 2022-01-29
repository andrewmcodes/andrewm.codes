---
title: Colophon
description: A bit about how this site was made.
permalink: /colophon/
no_index: false
date: "2022-01-29T12:27:25.003Z"
last_modified_at: "2022-01-29T22:35:16.442Z"
---

## Typography

I am using [IBM Plex Sans][1] on this site, a nice variable font, that I am self hosting. For markdown pages, I am using [the Tailwind CSS typography plugin][2] with a few modifications.

## Technologies

[Bridgetown][3] does most of the heavy lifting on this site - it's a Ruby based static site generator that I have fallen in love with.

I am using [Tailwind CSS][4] and [ViewComponent][5] to build and design the UI. All posts are written in [Kramdown flavored markdown][6] with ViewComponent's sprinkled in. I store all of the images in [Cloudinary][7] and get my icons from [Nucleo][8].

Under the hood, [esbuild][9] is handling asset bundling. I use almost no JavaScript on this site, but I have sprinkled [Alpine.js][10] here and there for small interactions.

## Deployment

This site is [open source on GitHub][11] and that is how I deploy. The site is hosted on [Vercel][12] and all pushes to the main branch trigger a deploy. I also use [Cloudflare][13] for DNS and domain management.

## Tracking

I am using [Plausible Analytics][14], which is a GDPR, CCPA and cookie law compliant site analytics tool. I chose a privacy focused tool because I just want to know what pages are popular, not get a breakdown of the users. This is a personal site afterall.

For the curious: you can find my public analytics dashboard on the [analytics page.][15]

## Third-party Service Providers

The only third-party service provider that will process and store any entered data is the newsletter form, which is backed by [Revue][16]. Read their [terms of service][17] and [privacy policy.][18]

## How to make a request about your data

You can contact me to ask me what data I hold about you, which is probably an email address and name at most, who has access to it and how it is being used. I will delete any data about you that I hold if you ask me to.

[1]: https://www.ibm.com/plex/
[2]: https://github.com/tailwindlabs/tailwindcss-typography
[3]: https://bridgetownrb.com
[4]: https://tailwindcss.com
[5]: https://viewcomponent.org
[6]: https://kramdown.gettalong.org
[7]: https://cloudinary.com/invites/lpov9zyyucivvxsnalc5/ztosjslptijb8cyexrrt?t=default
[8]: https://nucleoapp.com/?ref=11689
[9]: https://esbuild.github.io
[10]: https://alpinejs.dev
[11]: https://github.com/andrewmcodes/andrewm-codes-site
[12]: https://vercel.com/
[13]: https://www.cloudflare.com
[14]: https://plausible.io/
[15]: /analytics/
[16]: https://www.getrevue.co
[17]: https://www.getrevue.co/terms
[18]: https://www.getrevue.co/privacy
